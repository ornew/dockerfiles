# syntax = docker/dockerfile:experimental

ARG builder_image
ARG base_image

FROM $builder_image AS builder

RUN --mount=type=cache,target=/tmp \
 set -ex \
 && cd /tmp \
 && curl -fsSLo openjdk.tar.gz https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz \
 && tar xzf openjdk.tar.gz \
 && ls -alh \
 && mv jdk-11 /opt/java

FROM $base_image

ENV JAVA_HOME="/opt/java"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=builder /opt/java/ /opt/java/
