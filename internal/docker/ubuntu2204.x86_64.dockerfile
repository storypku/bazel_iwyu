FROM ubuntu:22.04 as build-stage

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    file \
    gawk \
    gnupg2 \
    less \
    software-properties-common \
    wget \
    xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --progress=dot:giga https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 16

RUN apt-get update && apt-get -y install --no-install-recommends \
    autoconf \
    automake \
    bash-completion \
    build-essential \
    libclang-16-dev \
    cmake \
    libtool \
    gcc \
    g++ \
    git \
    patch \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install prereq for building IWYU 0.20
RUN apt-get update && apt-get -y install --no-install-recommends \
    libtinfo-dev \
    zlib1g-dev \
    libzstd-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/

# Download iwyu repo
RUN wget --progress=dot:giga https://github.com/include-what-you-use/include-what-you-use/archive/refs/tags/0.20.tar.gz \
    && tar xvf 0.20.tar.gz -C /tmp \
    && rm 0.20.tar.gz

# Build iwyu
COPY ../build_iwyu_docker.sh /tmp/
RUN pushd include-what-you-use-0.20 \
    && ../build_iwyu_docker.sh

FROM scratch AS export-stage
COPY --from=build-stage /tmp/iwyu-0.20-x86_64-linux-gnu /
