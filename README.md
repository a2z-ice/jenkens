<pre><code>
In "Branch specifier" add "**/tags/*"
In "Script path" add "deploy/k8s/k8s-jenkinsfile"
</code></pre>

# Docker java memory management
<pre><code>
logging:
driver: "json-file"
options:
max-size: "200k"
max-file: "10"

----Older version of JDK---------
How my vm shows MaxHeap in container
docker run -it --rm --cpus=1 --memory=256M  openjdk:8u141-slim java -XX:+PrintFlagsFinal -version|grep MaxHeap

Max Thread:

docker run -it --rm --cpus=1 --memory=256M  openjdk:8u141-slim java -XX:+PrintFlagsFinal -version|grep Threads

--
docker pull openjdk:8u242-jre-buster


----New version of JDK which is container aware---------
docker run -it --rm --cpus=1 --memory=256M  openjdk:8u222-slim java -XX:+PrintFlagsFinal -XX:+UseParallelGC -XX:+UnlockDiagnosticVMOptions -XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics -version|grep MaxHeap

docker run -it --rm --cpus=1 --memory=256M  openjdk:8u222-slim java -XX:+PrintFlagsFinal -XX:+UseParallelGC -XX:+UnlockDiagnosticVMOptions -XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics -version|grep Threads

To run java with "-XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics" options gives you static of memory uplon successfull ending of java application

# docker run using resource limit
docker run -d --name mongo -p 30001:27017 -v /home/cent-master140/mongo-data:/data/db --cpus=0.25 --memory=75M mongo
# remove if any
docker ps -q --filter "name=mongo" | grep -q . && docker stop mongo && docker rm -f mongo

# docker run env from file
$ docker run --env-file=env_file_name alpine env

# will return success but show error
docker stop mongo || true && docker rm mongo || true
</code></pre>

SSH without prompt

<pre>
<code>
# setting up SSH
RUN mkdir /root/.ssh 

COPY ./cert/id_rsa /root/.ssh 
COPY ./cert/id_rsa.pub /root/.ssh
# allow user to read id_rsa file for ssh to git which is being create from a pc
# id_rsa is private key and the public key is in github.com
RUN chmod 400 /root/.ssh/id_rsa

# Create folder to store of_ec2_instance.pem file of EC2 instance
RUN mkdir /ssh 
COPY ./cert/of_ec2_instance.pem /ssh
RUN chmod 400 /ssh/of_ec2_instance.pem

# to allow ip and host for prompless ssh
RUN ssh-keyscan -H IP_ADDRS_OF_EC2_INSTANCE >> ~/.ssh/known_hosts
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
# known_hosts file will automatically be created and second instruction will be appended its content

</code>
</pre>


for ssh connection https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/

# ssh connection
# Create user
<pre><code>
sudo useradd {user name i.e. prod-user}
# Create ssh key in jenkins server
ssh-keygen -f {any name i.e. prod then double return}
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
ssh -i {prod ssh file} {user i.e. prod-user}@{ip or host name of the machine}
# Create deploy folder in git project in jenkins for transfer configuration
mkdir deploy && cd deploy
vi deploy.sh
  #!/bin/sh
  echo maven-project > /tmp/.auth
  echo $BUILD_TAG >> /tmp/.auth
  echo $PASS >> /tmp/.auth (the password of docker hub for image to push/pull)
  # to transfer the .auth file use scp
  scp -i {prod ssh private key } /tmp/.auth {user i.e. prod-user}@{ip or host name of the machine}:/tmp/.auth
  # Use full path of prod file better place this file in /opt/ folder and use this path /opt/prod

# to change woner to specific user id
sudo chown 1000 {file with full location}
  sudo chown 100 /opt/prod
# go to production machine after run the /tmp/.auth copy instruction
export IMAGE=$(sed -n '1p' /tmp/.auth) <--copy first line of a given file
export TAG=$(sed -n '2p' /tmp/.auth) <--copy second line of a given file
export PASS=$(sed -n '3p' /tmp/.auth) <--copy third line of a given file

# Create shell script for deployment in production pc
vi deploy.sh
 #!/bin/bash
 
export IMAGE=$(sed -n '1p' /tmp/.auth)
export TAG=$(sed -n '2p' /tmp/.auth)
export PASS=$(sed -n '3p' /tmp/.auth)

docker login -u {username} -p $PASS
cd ~/maven && docker-compose up -d
# save and exit
# Now set executable permission
chmod +x deploy.sh

# After transfer publish and .auth file to deployment pc run following command to execute ublish.sh file

ssh -i /opt/prod prod-user@ip-of-production-server "/tmp/publish"

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
