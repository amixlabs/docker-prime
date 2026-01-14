FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    gosu \
    curl \
    tidy \
    gnupg \
    make \
    xsltproc

COPY install.sh /usr/local/bin/
RUN install.sh

RUN a2enmod proxy proxy_fcgi setenvif rewrite headers \
    && a2enconf php8.1-fpm \
    && a2dissite 000-default

VOLUME [ "/app/log", "/app/ses" ]

RUN cd /var/log/apache2 && \
    rm -f access_log error_log && \
    ln -s /app/log/access_log access_log && \
    ln -s /dev/stdout error_log

WORKDIR /app

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

CMD ["bash"]