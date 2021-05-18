FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev \
        liblzma-dev \
        python-openssl \
        git \
        bats \
    && rm -rf /var/lib/apt/lists/*

ENV PYENV_BASE_ROOT "/pyenv"
ENV PYENV_TEST_ROOT "/pyenv-test"
ENV PYENV_LOCAL_SHIM "/root/.pyenv_local_shim"

COPY ./tmp/pyenv /pyenv
COPY ./tmp/pyenv-test /pyenv-test
RUN mkdir -p /tmp/test_home

RUN eval "$(pyenv init -)"
