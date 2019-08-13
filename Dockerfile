FROM ubuntu:latest


RUN apt-get update && \
    apt-get install -y \
            build-essential \
            bind9 \
            dnsutils \
            cron \
            nginx \
            curl \
            unzip \
            libnet-dns-perl \
            libwww-perl 
RUN rm -rf /var/lib/apt/lists/*

ADD etc/latest-git /latest-git
RUN /usr/bin/curl -L -o /tmp/sackconfig.zip https://github.com/jcapayne/SackConfig/archive/master.zip && \ 
    /usr/bin/unzip /tmp/sackconfig.zip && \ 
    ln -s /SackConfig-master /SackConfig

ADD bin/docker-entrypoint.sh /docker-entrypoint.sh
ADD etc/named.conf /etc/bind/
ADD etc/nginx.conf /etc/nginx/
ADD etc/crontab /etc/cron.d/sackfigurator
RUN touch /var/log/cron.log
RUN mkdir /etc/bind/SackConfig
RUN ln -s /etc/bind/SackConfig/sackdns.conf /etc/bind/sackdns.conf
ADD bin/generate.sh /SackConfig
ADD bin/run-undelegated.sh /SackConfig

# expose port 80 if web container
# volume mount:
#   - web config
#   - sack.conf
#   - /tmp/sackfigurator

ENTRYPOINT [ "/docker-entrypoint.sh" ]

