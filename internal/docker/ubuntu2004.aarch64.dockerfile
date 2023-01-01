FROM arm64v8/ubuntu:20.04
COPY sources.list.cn.aarch64 /etc/apt/sources.list
RUN apt-get update && apt-get -y install --no-install-recommends \
  ca-certificates \
  curl \
  file \
  gawk \
  gnupg2 \
  less \
  python3 \
  sed \
  software-properties-common \
  wget \
  xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y install --no-install-recommends \
  bash-completion \
  build-essential \
  autoconf \
  automake \
  libtool \
  gcc \
  g++ \
  git \
  patch \
  pkg-config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY installers/installer_base.sh \
     installers/install_cmake.sh \
     /tmp/installers/

RUN bash /tmp/installers/install_cmake.sh

# Install prereq for IWYU 0.19
RUN apt-get update && apt-get -y install \
    libtinfo-dev \
    zlib1g-dev
