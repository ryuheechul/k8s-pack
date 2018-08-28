FROM node:8.9.4-alpine

LABEL MAINTAINER=ryuhcii@gmail.com

ENV KOPS_VERSION=1.10.0
ENV KUBECTL_VERSION=v1.10.7

RUN apk --no-cache add ca-certificates \
  && apk --no-cache add --virtual build-dependencies curl \
  && curl -O --location --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl \
  && apk del --purge build-dependencies

ENV STERN_VERSION=1.6.0
ENV KUBELESS_VERSION=v0.6.0

RUN apk --update add bash make curl build-base coreutils \
     openssl yajl-dev zlib-dev cyrus-sasl-dev openssl-dev \
     zip vim python python3

#vim
RUN rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi
RUN printf "set number\nsyntax on\n" > ~/.vimrc

#stern
RUN curl -LO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 \
     && mv stern_linux_amd64 /usr/local/bin/stern \
     && chmod +x /usr/local/bin/stern

#kube-shell
RUN pip3 install --upgrade pip && pip3 install kube-shell

#kubeless
RUN curl -LO https://github.com/kubeless/kubeless/releases/download/${KUBELESS_VERSION}/kubeless_linux-amd64.zip \
     && unzip kubeless_linux-amd64.zip \
     && mkdir kubeless-bin && unzip kubeless_linux-amd64.zip -d kubeless-bin \
     && mv kubeless-bin/bundles/kubeless_linux-amd64/kubeless /usr/local/bin/ \
     && rm -rf kubeless-bin kubeless_linux-amd64.zip

#serverless
RUN npm i -g serverless

ENTRYPOINT /bin/ash
