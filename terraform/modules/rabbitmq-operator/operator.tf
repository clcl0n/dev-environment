resource "null_resource" "rabbitmq_cluster_operator" {
  triggers = {
    version          = var.operator_version
    kube_config_path = var.kube_config_path
  }

  # cert-manager isn't installed in this cluster, so the Certificate/Issuer resources in the
  # manifest fail to apply and the webhook server has no TLS cert to serve. Disable webhooks
  # on the operator (ENABLE_WEBHOOKS=false is a supported operator env var) and drop the
  # webhook registrations/cert volume that depend on cert-manager instead of installing it.
  provisioner "local-exec" {
    command = <<-EOT
      kubectl --kubeconfig ${var.kube_config_path} apply --server-side -f https://github.com/rabbitmq/cluster-operator/releases/download/${var.operator_version}/cluster-operator.yml || true
      kubectl --kubeconfig ${var.kube_config_path} -n rabbitmq-system set env deployment/rabbitmq-cluster-operator ENABLE_WEBHOOKS=false
      kubectl --kubeconfig ${var.kube_config_path} -n rabbitmq-system patch deployment rabbitmq-cluster-operator --type=json -p '[{"op":"remove","path":"/spec/template/spec/containers/0/volumeMounts/0"}]' || true
      kubectl --kubeconfig ${var.kube_config_path} -n rabbitmq-system patch deployment rabbitmq-cluster-operator --type=json -p '[{"op":"remove","path":"/spec/template/spec/volumes/0"}]' || true
      kubectl --kubeconfig ${var.kube_config_path} delete mutatingwebhookconfiguration cluster-operator-mutating-webhook-configuration --ignore-not-found
      kubectl --kubeconfig ${var.kube_config_path} delete validatingwebhookconfiguration cluster-operator-validating-webhook-configuration --ignore-not-found
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl --kubeconfig ${self.triggers.kube_config_path} delete -f https://github.com/rabbitmq/cluster-operator/releases/download/${self.triggers.version}/cluster-operator.yml --ignore-not-found"
  }
}
