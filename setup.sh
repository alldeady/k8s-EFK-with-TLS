# !/bin/sh

minikube start --cpus=4 --memory 8192
minikube addons enable default-storageclass
minikube addons enable storage-provisioner
minikube addons enable dashboard

# add namespace
kubectl create -f kube-logging.yaml

# add certs
kubectl create secret generic -n kube-logging elastic-certs --from-file=certs/rootCA.pem --from-file=certs/es.key --from-file=certs/es.crt
kubectl create secret generic -n kube-logging kibana-certs --from-file=certs/rootCA.pem --from-file=certs/kib.key --from-file=certs/kib.crt
kubectl create secret generic -n kube-logging fluent-bit-certs --from-file=certs/rootCA.pem --from-file=certs/fluent-bit.key --from-file=certs/fluent-bit.crt

# add helm repo
helm repo add elastic https://helm.elastic.co
helm repo add fluent https://fluent.github.io/helm-charts

# install elastic
helm install es elastic/elasticsearch -f es_values.yml -n kube-logging
kubectl rollout status sts/elasticsearch-master -n kube-logging

# install kibana
helm install kib elastic/kibana -f kib_values.yml -n kube-logging
kubectl rollout status deployment/kib-kibana -n kube-logging

# install fluent-bit
helm install fb fluent/fluent-bit -f fluent_values.yml -n kube-logging
while [[ $(kubectl get pods $(kubectl get pods -n kube-logging | grep fb-fl* | cut -d" " -f1) \
-n kube-logging -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; \
do echo "waiting for fluent bit" && sleep 20; done

echo "EFK stack is ready"
