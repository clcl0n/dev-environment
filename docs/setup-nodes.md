# Setup Kubernetes Cluster Nodes

## Etcd Node

1. Create VM
```sh
multipass launch -c 2 -m 3G -d 10G -n etcd --network br0 24.04
```

2. Setup Etcd node
```sh
curl -fL https://get.k3s.io | sh -s - server --cluster-init --disable-apiserver --disable-controller-manager --disable-scheduler --node-ip <ipv4 from `multipass list` 192.168.0.xxx>
```


## Control Plane Node

1. Create VM
```sh
multipass launch -c 3 -m 4G -d 10G -n control-plane --network br0 24.04
```

2. Retrieve token from Etcd node
```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```

3. Setup Control Plane node
```
curl -sfL https://get.k3s.io | sh -s - server --token <token> --disable-etcd --server https://<ipv4 of etcd from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx>
```

## Thinkpad Worker Node
1. Create VM
```sh
multipass launch -c 11 -m 24G -d 420G -n thinkpad-worker1 --network br0 24.04
```

2. Setup Worker node
```sh
curl -sfL https://get.k3s.io | sh -s - agent --server https://<ipv4 of control-plane from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx> --token <token>
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
curl -sfL https://get.k3s.io | sh -s - agent --server https://<ipv4 of control-plane from `multipass list` 192.168.0.xxx>:6443 --node-ip <ipv4 from `multipass list` 192.168.0.xxx> --token <token>
```