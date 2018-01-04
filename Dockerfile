FROM airhelp/kops:1.8.0

MAINTAINER ryuhcii@gmail.com

ENV STERN_VERSION=1.6.0
ENV KUBELESS_VERSION=v0.3.2

RUN apk update && apk add vim curl python3 nodejs

#vim
RUN rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi
RUN printf "set number\nsyntax on\n" > ~/.vimrc

#stern
RUN curl -LO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 \
     && mv stern_linux_amd64 /usr/local/bin/stern \
     && chmod +x /usr/local/bin/stern

#kube-shell
RUN pip3 install --upgrade pip && pip install kube-shell

#kubeless
RUN curl -LO https://github.com/kubeless/kubeless/releases/download/${KUBELESS_VERSION}/kubeless_linux-amd64.zip \
     && unzip kubeless_linux-amd64.zip \
     && mkdir kubeless-bin && unzip kubeless_linux-amd64.zip -d kubeless-bin \
     && mv kubeless-bin/bundles/kubeless_linux-amd64/kubeless /usr/local/bin/ \
     && rm -rf kubeless-bin kubeless_linux-amd64.zip

#serverless
RUN npm i -g serverless
