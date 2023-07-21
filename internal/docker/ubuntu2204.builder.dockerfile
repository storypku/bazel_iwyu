FROM ubuntu:22.04

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

RUN apt-get update && apt-get -y install --no-install-recommends \
    autoconf \
    automake \
    bash-completion \
    build-essential \
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

COPY ../installers/install_llvm_release.sh /tmp
RUN /tmp/install_llvm_release.sh

# Download iwyu repo
RUN wget --progress=dot:giga https://github.com/include-what-you-use/include-what-you-use/archive/refs/tags/0.20.tar.gz \
    && tar xvf 0.20.tar.gz -C /tmp \
    && rm 0.20.tar.gz

# Build iwyu
COPY ../build_iwyu_docker.sh /tmp/

# Apply angle-quote-curse workaround
COPY ../patches /tmp/patches

RUN pushd include-what-you-use-0.20 \
    && patch -p1 < /tmp/patches/p01_angle_quote_curse_dirty_fix.patch \
    && ../build_iwyu_docker.sh
