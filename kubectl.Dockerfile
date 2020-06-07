FROM jenkins/jenkins:lts-alpine
USER root
COPY .kube .kube
# Pipeline
RUN /usr/local/bin/install-plugins.sh workflow-aggregator && \
    /usr/local/bin/install-plugins.sh github && \
    /usr/local/bin/install-plugins.sh ws-cleanup && \
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
    /usr/local/bin/install-plugins.sh kubernetes && \
    /usr/local/bin/install-plugins.sh docker-workflow && \
    /usr/local/bin/install-plugins.sh kubernetes-cli && \
    /usr/local/bin/install-plugins.sh github-branch-source

# install Maven, Java, Docker, AWS
RUN apk upgrade --available && sync && apk add --no-cache maven \
    openjdk8 \
    docker \
    curl \
    gettext \
    py-pip python-dev libffi-dev openssl-dev gcc libc-dev make \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \ 
    && chmod +x ./kubectl \ 
    && mv ./kubectl /usr/local/bin/kubectl \
    && mv .kube ~/
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
