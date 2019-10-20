FROM debian:stable
MAINTAINER RedOracle

ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.name='Monero Miner based on Xmrig with 0 fee by Redoracle' \
      org.label-schema.description='UNOfficial Xrig miner docker image' \
      org.label-schema.usage='https://www.redoracle.com/docker/' \
      org.label-schema.url='https://www.redoracle.com/' \
      org.label-schema.vendor='Red0racle S3curity' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run --rm redoracle/xrig' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti redoracle/xrig' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="RedOracle <info@redoracle.com>"

RUN set -x \
    && sed -i -e 's/^root::/root:*:/' /etc/shadow \
    && apt-get -yqq update \                                                       
    && apt-get -yqq dist-upgrade \
    && apt-get -yqq install curl wget bash tmux cmake g++ pkg-config neofetch vim-common libwebsockets-dev uuid-dev libjson-c-dev watch jq watch net-tools geoip-bin geoip-database git build-essential cmake libuv1-dev libssl-dev libhwloc-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \   
    && mkdir -p /root/xrig \
    && cd /root/xrig \
    && git clone https://github.com/xmrig/xmrig.git \
    && sed -i -e 's/kDefaultDonateLevel = 5/kDefaultDonateLevel = 0/' xmrig/src/donate.h \
    && sed -i -e 's/kMinimumDonateLevel = 1/kMinimumDonateLevel = 0/' xmrig/src/donate.h \
    && cd xmrig && mkdir build && cd build \
    && cmake .. \
    && make \
    && cp xmrig ~/ \
    && cd \
    && rm -rf xrig \
    && mkdir -p /root/xrig-proxy \
    && cd /root/xrig-proxy \
    && git clone https://github.com/xmrig/xmrig-proxy.git \
    && mkdir xmrig-proxy/build \
    && cd xmrig-proxy/build \
    && cmake .. \
    && make \
    && cp xmrig-proxy ~/ \
    && cd && rm -rf xrig-proxy \
    && echo "./xmrig --url 188.138.100.69:8000 --nicehash --rig-id Zulu01 --keepalive --donate-level 0 -t 10" >> /root/start-xrig.sh
    
ENV \
DEBIAN_FRONTEND noninteractive \
ENV=/etc/profile \
USER=root \
PATH=/root/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH 

#CMD ["/bin/bash", "/root/start-xrig.sh"]
