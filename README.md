# jenkens
build -t jenkins-kube -f jenkins.Dockerfile .

docker run -it -v /var/run/docker.sock:/var/run/docker.sock --rm jenkins-kube

