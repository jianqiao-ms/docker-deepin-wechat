# syntax=docker/dockerfile:1

ARG DEEPIN_MIRROR="http://mirrors.ustc.edu.cn/deepin/"
ARG DEEPIN_RELEASE="apricot"
ARG DEEPIN_ROOTFS="/deepin-rootfs"

FROM debian:stable as init-builder

ARG DEEPIN_MIRROR
ARG DEEPIN_RELEASE
ARG DEEPIN_ROOTFS

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p $DEEPIN_ROOTFS/etc/apt /var/lib/debootstrap-cache && \
  sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt update && apt-get install -y multistrap gnupg

FROM init-builder as prepare-builder

ARG DEEPIN_MIRROR
ARG DEEPIN_RELEASE
ARG DEEPIN_ROOTFS

COPY trusted.gpg.d/* /etc/apt/trusted.gpg.d/
COPY trusted.gpg.d/* $DEEPIN_ROOTFS/etc/apt/trusted.gpg.d/

RUN <<EOF cat > /deepin.multistrap
[General]
arch=amd64
directory=$DEEPIN_ROOTFS
cleanup=true
noauth=true
unpack=true
explicitsuite=false
multiarch=
aptsources=Debian
bootstrap=Deepin

[Deepin]
packages=apt
source=$DEEPIN_MIRROR
keyring=debian-archive-keyring
suite=$DEEPIN_RELEASE
EOF

RUN <<EOF cat > $DEEPIN_ROOTFS/etc/apt/sources.list
deb $DEEPIN_MIRROR $DEEPIN_RELEASE main non-free contrib
EOF

RUN <<EOF cat > $DEEPIN_ROOTFS/cleanup
#! /bin/sh
env DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
apt-get clean
find /var/lib/apt/lists -type f -delete
find /var/cache -type f -delete
find /var/log -type f -delete
exit 0
EOF

RUN chmod a+x $DEEPIN_ROOTFS/cleanup


FROM prepare-builder as run-builder
RUN multistrap -f /deepin.multistrap

FROM run-builder as builder

ARG DEEPIN_ROOTFS

RUN chroot $DEEPIN_ROOTFS /usr/bin/apt-get update && \
  chroot $DEEPIN_ROOTFS env DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
  chroot $DEEPIN_ROOTFS /cleanup

FROM scratch as deepin

ARG DEEPIN_MIRROR
ARG DEEPIN_RELEASE
ARG DEEPIN_ROOTFS

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash
ENV LANG=en_US.UTF-8

COPY --from=builder $DEEPIN_ROOTFS /

RUN <<EOF cat > /etc/apt/sources.list
deb $DEEPIN_MIRROR $DEEPIN_RELEASE main non-free contrib
EOF

RUN apt update && apt install -y --no-install-recommends apt-transport-https \
  ca-certificates \
  dbus-x11 \
  deepin-keyring \
  gnupg \
  libcups2 \
  libpulse0 \
  libxv1 \
  locales-all

RUN <<EOF cat > /etc/apt/sources.list.d/appstore.list
# Written by deepin-home-appstore-client
deb https://com-store-packages.uniontech.com/appstore deepin appstore
EOF

RUN apt update