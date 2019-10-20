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
      org.label-schema.name='Cardano Node by Redoracle' \
      org.label-schema.description='UNOfficial Xrig miner docker image' \
      org.label-schema.usage='https://www.redoracle.com/docker/' \
      org.label-schema.url='https://www.redoracle.com/' \
      org.label-schema.vendor='Red0racle S3curity' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run --rm redoracle/xrig-node-docker' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti redoracle/xrig-node-docker' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="RedOracle <info@redoracle.com>"

VOLUME /datak

RUN set -x \
    && sed -i -e 's/^root::/root:*:/' /etc/shadow \
    && apt-get -yqq update \                                                       
    && apt-get -yqq dist-upgrade \
    && apt-get -yqq install curl wget bash tmux cmake g++ pkg-config neofetch vim-common libwebsockets-dev libjson-c-dev watch jq watch net-tools geoip-bin geoip-database git build-essential cmake libuv1-dev libssl-dev libhwloc-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \   
    && mkdir -p /root/xrig \
    && cd /root/xrig \
    && wget https://raw.githubusercontent.com/clio-one/cardano-on-the-rocks/master/scripts/Jormungandr/jtools.sh \
    && git clone https://github.com/xmrig/xmrig.git \
    && sed -i -e 's/donate.h//' xmrig/src/base/net/stratum/Pools.cpp \
    && sed -i -e 's/donate.h//' xmrig/src/base/kernel/config/BaseConfig.cpp \
    && cd xmrig && mkdir build && cd build \
    && cmake .. \
    && make && make install \
    && echo "ttyd -p 9001 -R tmux new -A -s ttyd &" >> ~/web_interface_tmux.sh \
    && echo "tmux attach" >> ~/web_interface_tmux.sh \
    && echo "tmux source ~/.tmux.conf" >> ~/web_interface_tmux.sh \
    && cp /usr/share/doc/tmux/example_tmux.conf ~/.tmux.conf \
    && echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> ~/.tmux.conf \
    && echo "set -g @resurrect-save 'S'" >> ~/.tmux.conf \
    && echo "set -g @resurrect-restore 'R'" >> ~/.tmux.conf \
    && echo "set -g @plugin 'tmux-plugins/tmux-continuum'" >> ~/.tmux.conf \
    && echo "set -g @colors-solarized 'dark'" >> ~/.tmux.conf \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && echo "run-shell ~/.tmux/plugins/tpm/resurrect.tmux" >> ~/.tmux.conf \
    && echo "run -b '~/.tmux/plugins/tpm/tpm'" >> ~/.tmux.conf \
    
    
ENV \
DEBIAN_FRONTEND noninteractive \
ENV=/etc/profile \
USER=root \
PATH=/bin:/sbin:/usr/bin:/usr/sbin:$PATH 

#CMD ["/bin/bash", "/root/jormungandr/script/start-pool.sh"]

EXPOSE 8000
