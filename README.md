# Copy .kube folder from k8s master node

scp -r pi@192.168.0.102:~/.kube . <== here my pi ip address of master node is 192.168.0.102

docker build -t jenkins-kube -f pi-alpine-kubectl-docker.Dockerfile --rm .

docker run -it -v /var/run/docker.sock:/var/run/docker.sock --rm jenkins-kube

<pre><code>
docker run \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Volumes/Other/RandD/jenkens-k8s-cicd/jenkins-vol:/var/jenkins_home \
  -p 8080:8080 -d jenkins-docker-after-install
</code></pre>
