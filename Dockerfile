FROM airhelp/kops:1.8.0

MAINTAINER ryuhcii@gmail.com

RUN apk update && apk add vim
RUN rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi
RUN printf "set number\nsyntax on\n" > ~/.vimrc

RUN apk add curl
RUN curl -LO https://github.com/wercker/stern/releases/download/1.5.1/stern_linux_amd64 \
     && mv stern_linux_amd64 /usr/local/bin/stern \
     && chmod +x /usr/local/bin/stern

RUN apk update && apk add python3
RUN pip3 install --upgrade pip && pip install kube-shell
