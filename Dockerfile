FROM debian:stretch-slim as base

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        ninja-build \
        python \
        python-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home
RUN git clone --branch known-good --single-branch https://github.com/google/shaderc.git \
    && cd shaderc \
    && ./update_shaderc_sources.py \
    && mkdir src/build \
    && cd src/build \
    && cmake -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        .. \
    && ninja install

FROM debian:stretch-slim
COPY --from=base /usr/local/bin /usr/local/bin
