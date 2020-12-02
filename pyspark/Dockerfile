# syntax = docker/dockerfile:experimental

ARG base_image
FROM $base_image

ENV PYTHONPYCACHEPREFIX=/tmp/__pycache__
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-src.zip"
ENV PYSPARK_PYTHON="python3"
ENV PYSPARK_DRIVER_PYTHON="python3"

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/tmp \
 set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
      python3.8 \
      python3-pip \
 && ls -alh ${SPARK_HOME}/python \
 && ls -alh ${SPARK_HOME}/python/lib \
 && py4j=$(find ${SPARK_HOME}/python/lib/ -type f -name "py4j-*-src.zip") \
 && ln -svf $py4j ${SPARK_HOME}/python/lib/py4j-src.zip
