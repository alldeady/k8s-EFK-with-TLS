# !/bin/sh

kubectl run nginx --image=nginx

while [[ $(kubectl get pods nginx -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; \
do echo "waiting for nginx" && sleep 10; done

kubectl port-forward nginx 8081:80 &
while true; do curl localhost:8081; sleep 2; done
