#!/bin/sh
# Work in progress
sudo systemctl enable --now kubelet
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir ~/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/opc/.kube/config
sudo chown opc:opc /home/opc/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# join workers

# your Pod network must not overlap with any of the host networks as this can cause issues
# Provision networking:
# Weave:
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# Flannel:
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces
