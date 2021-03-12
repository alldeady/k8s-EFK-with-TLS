# !/bin/sh

minikube start --cpus=4 --memory 8192
minikube addons enable default-storageclass
minikube addons enable storage-provisioner
minikube addons enable dashboard

eval $(minikube docker-env)
export MINIKUBE_IP=$(minikube ip)

kubectl create -f kube-logging.yaml

kubectl create secret generic -n kube-logging elastic-certificates --from-file=certs/rootCA.pem --from-file=certs/es01.key --from-file=certs/es01.crt

kubectl create secret generic -n kube-logging kibana-keystore --from-file=certs/rootCA.pem --from-file=certs/kib01.key --from-file=certs/kib01.crt

kubectl create secret generic -n kube-logging fluent-bit-serts --from-file=certs/rootCA.pem --from-file=certs/fluent-bit.key --from-file=certs/fluent-bit.crt
