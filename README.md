# Copy .kube folder from k8s master node

scp -r pi@192.168.0.102:~/.kube . <== here my pi ip address of master node is 192.168.0.102

build -t jenkins-kube -f alpine-kubectl-docker.Dockerfile --rm .

docker run -it -v /var/run/docker.sock:/var/run/docker.sock --rm jenkins-kube

