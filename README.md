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

#Simple docker dashboard
<pre><code>
docker run --name portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
</code></pre>

# For Alpine the shell script file must contain following as the first line content
<pre><code>
#!/bin/sh
</pre></code>
