# syntax = docker/dockerfile:experimental

ARG builder_image
ARG base_image

FROM $builder_image AS builder

ARG hadoop_version="3.2"
ARG spark_version="3.0.1"
ARG spark_checksum="E8B47C5B658E0FBC1E57EEA06262649D8418AE2B2765E44DA53AAF50094877D17297CC5F0B9B35DF2CEEF830F19AA31D7E56EAD950BBE7F8830D6874F88CFC3C"

ENV SPARK_HOME="/opt/spark"
ENV PATH="${SPARK_HOME}/bin:${PATH}"

RUN set -ex \
 && cd /tmp \
 && spark_dist="spark-${spark_version}-bin-hadoop${hadoop_version}" \
# && url=$( \
#      curl -sSLo- "https://www.apache.org/dyn/closer.lua/spark/spark-${spark_version}/${spark_dist}.tgz?as_json" \
#      | python3 -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") \
 && url="https://ftp.riken.jp/net/apache/spark/spark-${spark_version}/${spark_dist}.tgz" \
 && curl -fsSLO "${url}" \
 && echo "${spark_checksum} *${spark_dist}.tgz" | sha512sum -c - \
 && tar xzf "${spark_dist}.tgz" -C "/opt" \
    --owner root --group root --no-same-owner \
 && ln -svf "/opt/${spark_dist}" "${SPARK_HOME}" \
 && rm -rf \
    "${SPARK_HOME}/examples" \
    "${SPARK_HOME}/data" \
    "${SPARK_HOME}/tests" \
    "${SPARK_HOME}/kubernetes/tests" \
    "${SPARK_HOME}/R" \
    "${SPARK_HOME}/yarn"

FROM $base_image

COPY --from=builder /usr/bin/tini /usr/bin/tini
COPY --from=builder /opt/spark/ /opt/spark/

ARG OPENJDK_VERSION="11"

ENV SPARK_HOME="/opt/spark"
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/tmp \
 set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
      openjdk-${OPENJDK_VERSION}-jre-headless

ENTRYPOINT ["/opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh"]
