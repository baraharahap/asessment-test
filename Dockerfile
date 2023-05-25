FROM alpine:3.10.2

COPY . /app

RUN apk update \
    && apk add --no-cache \
       ansible \
       bash \
       curl \
       git \
       jq \
       openssh-client \
       openssl \
       py3-pip \
       sshpass \
       tar

RUN apk add --no-cache --virtual .build-deps \
      build-base \
      dbus-dev \
      dbus-glib \
      dbus-glib-dev \
      gcc \
      libc-dev \
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      openssl-dev \
      python3-dev \
    && python3 -m pip install --no-cache-dir -r /app/requirements.txt \
    && apk del .build-deps

RUN curl -o /tmp/packer.zip https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip \
    && unzip /tmp/packer.zip -d /usr/local/bin/

WORKDIR /app

ENTRYPOINT [ "/usr/bin/ansible-playbook" ]