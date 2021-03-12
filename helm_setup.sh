helm repo add elastic https://helm.elastic.co

helm repo add fluent https://fluent.github.io/helm-charts


helm install es elastic/elasticsearch -f es_values.yml -n kube-logging

helm install fb fluent/fluent-bit -f fluent_values.yml -n kube-loggingng

helm install kib elastic/kibana -f kib_values.yml -n kube-logging
