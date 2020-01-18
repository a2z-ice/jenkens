FROM alpine:3.7
USER root
COPY .kube .kube

RUN apk add --no-cache curl docker \
&& wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl\ 
&& chmod +x ./kubectl \ 
&& mv ./kubectl /usr/local/bin/kubectl \
&& cp -r .kube ~/

ENTRYPOINT ["sh"]
