# syntax=docker/dockerfile:1.2

FROM nginx

RUN set -x \
  && apt-get update \
  && apt-get install -y curl git build-essential libssl-dev \
  && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.17.1

RUN rm /bin/sh && ln -sf /bin/bash /bin/sh
RUN set -x \
  && mkdir -p $NVM_DIR \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN set -x \
  && rm -rf /usr/share/nginx/html \
  && git clone https://github.com/cidrblock/drawthe.net.git /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

