# ssh connection
# Create user
<pre><code>
sudo useradd <user name i.e. prod-user>
# Create ssh key in jenkins server
ssh-keygen -f <any name i.e. prod then double return>
# Copy ssh key content i.e prod.pub content
cat prod.pub
# Go to production/deployment pc and do following
sudo su
su prod-user
cd /home/prod-user/
mkdir .ssh
chmod 700 .ssh
vi .ssh/authorizeed_keys (past the content of prod.pub content but remove the email address)
chmod 400 .ssh/authorizeed_keys

# From jenkins server copy file content from prod file using cat
# Now from any pc create prod file using any editor
vi/nano/code pord (past prod file content here)
# Try to ssh into production machine
chmod 400 prod (change permission to prod file)
ssh -i <prod ssh file> <user i.e. prod-user>@<ip or host name of the machine>
# Create deploy folder in git project in jenkins for transfer configuration
mkdir deploy && cd deploy
vi deploy.sh
  #!/bin/sh
  echo maven-project > /tmp/.auth
  echo $BUILD_TAG >> /tmp/.auth
  echo $PASS >> /tmp/.auth (the password of docker hub for image to push/pull)
  # to transfer the .auth file use scp
  scp -i <prod ssh private key > /tmp/.auth <user i.e. prod-user>@<ip or host name of the machine>:/tmp/.auth
  # Use full path of prod file better place this file in /opt/ folder and use this path /opt/prod

</pre></code>

# Install docker-compose in alpine container
Docker Compose
To install docker-compose, first install pip:
<pre><code>
apk add py-pip
</pre></code>

Since docker-compose version 1.24.0, you also need some dev dependencies:
<pre><code>
apk add python-dev libffi-dev openssl-dev gcc libc-dev make
</pre></code>

Then install docker-compose, run:
<pre><code>
pip install docker-compose
</pre></code>
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
