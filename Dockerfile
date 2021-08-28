FROM ubuntu:21.04

WORKDIR /opt

ENV NIM_VER="1.4.8"
ENV NIM_BASE="nim-${NIM_VER}"
ENV NIM_ARCH="${NIM_BASE}.tar.xz"

RUN apt-get update && \
    apt-get install -y build-essential wget && \
    apt-get install -y gcc-11 g++-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 && \
    wget "https://nim-lang.org/download/${NIM_ARCH}" && \
    tar -axf "${NIM_ARCH}" && \
    mv "${NIM_BASE}" nim && \
    rm "${NIM_ARCH}"

WORKDIR /opt/nim

RUN sh build.sh && \
    bin/nim c koch && \
    ./koch boot -d:release && \
    ./koch tools

WORKDIR /

ENV PATH="/opt/nim/bin:${PATH}"