# syntax=docker/dockerfile:1.2

FROM nginx

RUN set -x \
  && apt-get update \
  && apt-get install -y curl git unzip build-essential libssl-dev \
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

RUN set -x \
  && rm /usr/share/nginx/html/build/images/aws/* \
  && mkdir /tmp/aws \
  && cd /tmp/aws \
  && curl -o aws.zip -sSL https://d1.awsstatic.com/webteam/architecture-icons/q1-2021/AWS-Architecture_Asset-Package_20210131.a41ffeeec67743738315c2585f5fdb6f3c31238d.zip \
  && unzip aws.zip \
  && unzip Asset-Package_20210131/Architecture-Service-Icons_01-31-2021.zip \
  && unzip Asset-Package_20210131/Category-Icons_01-31-2021.zip \
  && unzip Asset-Package_20210131/Resource-Icons_01-31-2021.zip \
  && find . -type d -name '__MACOSX' | xargs rm -rf \
  && find . -type f -name '*.svg' | xargs -i cp {} /usr/share/nginx/html/build/images/aws \
  && chmod 644 -R /usr/share/nginx/html/build/images/aws \
  && chmod +x /usr/share/nginx/html/build/images/aws \
  && cd / && rm -rf /tmp/aws

RUN set -x \
  && mkdir -p /usr/share/nginx/html/build/images/google \
  && mkdir /tmp/google \
  && cd /tmp/google \
  && curl -o gcp.zip -sSL https://cloud.google.com/icons/files/google-cloud-icons.zip \
  && unzip gcp.zip \
  && find . -type d -name '__MACOSX' | xargs rm -rf \
  && find . -type f -name '*.svg' | xargs -i cp {} /usr/share/nginx/html/build/images/google \
  && chmod 644 -R /usr/share/nginx/html/build/images/google \
  && chmod +x /usr/share/nginx/html/build/images/google \
  && cd / && rm -rf /tmp/google

WORKDIR /usr/share/nginx/html

