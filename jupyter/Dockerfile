# syntax = docker/dockerfile:experimental

ARG builder_image

FROM $builder_image AS base

ENV PYTHONPYCACHEPREFIX=/tmp/__pycache__

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/tmp \
 set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -yq --no-install-recommends \
      python3.8 \
      python3-pip \
 && pip3 install "jupyterlab~=2.2.9"

FROM base AS build_jupyter

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/var/cache/npm \
 set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -yq --no-install-recommends \
      nodejs \
      npm \
 && npm config set cache /var/cache/npm/ --global \
 && jupyter labextension install --no-build \
      "@jupyterlab/server-proxy@2.1.1" \
      "@jupyterlab/toc" \
      "@jupyterlab/git@0.22.3" \
      "@jupyterlab/latex" \
      "@jupyterlab/shortcutui" \
      "@jupyter-widgets/jupyterlab-manager@2.0" \
      "jupyter-matplotlib@^0.7.2" \
      "jupyterlab-drawio" \
      "@krassowski/jupyterlab-lsp@2.0.8" \
      "@ryantam626/jupyterlab_code_formatter@1.3.6" \
 && jupyter lab build -y \
 && jupyter lab clean -y \
 && rm -rf /usr/local/share/jupyter/lab/extensions/ \
 && find /usr/local/share/jupyter/ -type f -name '*.js.map' -o -name '*.css.map' | xargs rm

FROM base AS jupyter

COPY --from=build_jupyter /usr/local/share/jupyter/lab /usr/local/share/jupyter/lab

RUN --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/tmp \
 set -ex \
 && pip3 install \
      "yapf~=0.30.0" \
      "isort~=5.6.4" \
      "python-language-server[all]~=0.36.1" \
      "jupyterhub~=1.2.1" \
      "ipywidgets~=7.5" \
      "ipympl~=0.5.7" \
      "widgetsnbextension~=3.5.1" \
      "jupyterlab-git==0.22.3" \
      "jupyter-server-proxy~=1.5.0" \
      "jupyter-lsp~=0.9.2" \
      "jupyterlab-code-formatter==1.3.6" \
 && jupyter nbextension enable --sys-prefix --py widgetsnbextension \
 && jupyter serverextension enable --sys-prefix --py jupyterlab_git \
 && jupyter serverextension enable --sys-prefix --py jupyterlab_code_formatter \
 && pip3 check \
 && find /usr/local/share/jupyterhub/ -type f -name '*.js.map' -o -name '*.css.map' | xargs rm
