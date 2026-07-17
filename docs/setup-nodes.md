# Setup Kubernetes Cluster Nodes

## Etcd Node

1. Create VM
```sh
multipass launch -c 2 -m 3G -d 10G -n k8s-etcd --network br0 --cloud-init cloud-init.yaml 26.04
```

cloud-init.yaml
```yaml
#cloud-config
write_files:
  - path: /etc/netplan/99-lan-default.yaml
    permissions: '0600'
    content: |
      network:
        version: 2
        ethernets:
          default:
            dhcp4-overrides:
              use-routes: false
          extra0:
            dhcp4-overrides:
              route-metric: 100
runcmd:
  - netplan apply
```

2. Setup Etcd node
```sh
curl -fL https://get.k3s.io | sh -s - server --cluster-init --disable-apiserver --disable-controller-manager --disable-scheduler --node-ip <ipv4 from `multipass list` 192.168.0.xxx> --flannel-iface ens4 
```


## Control Plane Node

1. Create VM
```sh
multipass launch -c 3 -m 4G -d 10G -n control-plane --network br0 --cloud-init cloud-init.yaml 26.04
```

2. Retrieve token from Etcd node
```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```

3. Setup Control Plane node
```sh
curl -sfL https://get.k3s.io | sh -s - server --flannel-iface ens4 --token <token> --disable-etcd --server https://<ipv4 of etcd from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx>
```

## Thinkpad Worker Node
1. Create VM
```sh
multipass launch -c 11 -m 24G -d 420G -n thinkpad-worker1 --network br0 --cloud-init cloud-init.yaml 26.04
```

2. Setup Worker node
```sh
curl -sfL https://get.k3s.io | sh -s - agent --flannel-iface ens4 --server https://<ipv4 of control-plane from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx> --token <token>
```

## Mac mini Worker Node

1. Create VM
- name mac-mini-worker1
- cpu 9
- ram 14G
- disk 175G
- bridged network = true (in settings set Bridged network to en0)

2. Setup Worker node
```sh
curl -sfL https://get.k3s.io | sh -s - agent --flannel-iface enp0s2 --server https://<ipv4 of control-plane from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx> --token <token>
```