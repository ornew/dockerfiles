# syntax = docker/dockerfile:experimental

ARG base_image=docker.io/ubuntu:focal-20201018
FROM $base_image

ARG tini_version="0.19.0"

SHELL ["/bin/bash", "-c"]

ENV LANG C.UTF-8

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/tmp \
 set -ex \
 && cd /tmp \
 && chown root:root /tmp \
 && chmod ugo+rwXt /tmp \
 && export DEBIAN_FRONTEND=noninteractive \
 && sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
    ca-certificates \
    gnupg \
    curl \
    git \
    gzip \
    bzip2 \
    unzip \
    openssh-client \
    tree \
 && curl -fsSLO "https://github.com/krallin/tini/releases/download/v${tini_version}/tini" \
 && chmod +x tini \
 && mv tini /usr/bin/tini
