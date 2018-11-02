apiVersion: v1
clusters:
- cluster:
    certificate-authority: /root/.minikube/ca.crt
    server: https://%%IP_ADDRESS%%:8443
  name: mac
contexts:
- context:
    cluster: mac
    user: minikube
  name: mac
current-context: mac
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /root/.minikube/apiserver.crt
    client-key: /root/.minikube/apiserver.key

