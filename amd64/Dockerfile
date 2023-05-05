# syntax=docker/dockerfile:1

FROM docker-deepin-wine6 as deepin-wine6

ENV DEBIAN_FRONTEND=noninteractive
ENV AUDIO_GID=63
ENV VIDEO_GID=39
ENV GID=1000
ENV UID=1000

#RUN apt update && apt install -y com.qq.weixin.deepin

RUN apt update && apt install -y curl && \
  curl -L -o /wechat.deb \
    https://com-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin.deepin/com.qq.weixin.deepin_3.4.0.38deepin6_i386.deb && \
  apt install -y -f ./wechat.deb

RUN mkdir /WeChatFiles && \
    chown -R deepin:deepin /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/deepin/WeChat Files"

VOLUME ["/WeChatFiles", "/home/deepin/.deepinwine"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENV LANGUAGE=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8
ENV TZ=UTC-8
ENTRYPOINT /entrypoint.sh