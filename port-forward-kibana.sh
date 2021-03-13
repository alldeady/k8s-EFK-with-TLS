# !/bin/sh

# listen on https://localhost:5601
kubectl port-forward $(kubectl get pods --namespace=kube-logging | grep kibana-* | cut -d" " -f1) 5601:5601 -n kube-logging
