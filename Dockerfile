FROM alpine
LABEL MAINTAINER="ZhangSean <zxf2342@qq.com>"

COPY entrypoint.sh /bin/entrypoint.sh

ENV CLOUD189_USERNAME= \
    CLOUD189_PASSWORD= \
    CLOUD189_CACHE_SIZE=256KB \
    CLOUD189_PROXY= \
    CLOUD189_SAVEDIR=/root/Downloads \
    CLOUD189_VERBOSE=0

ADD cloud189-*-linux-amd64.zip /tmp/

RUN unzip /tmp/cloud189-*-linux-amd64.zip && \
    mv cloud189 /bin/ && \
    rm -rf cloud189*

VOLUME [ "/root/Downloads" ]

ENTRYPOINT [ "/bin/entrypoint.sh" ]
