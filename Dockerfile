FROM debian:stretch-20180213

# Install all dependencies from manifest.scm
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bash \
    bison \
    cmake \
    coreutils \
    curl \
    device-tree-compiler \
    diffutils \
    doxygen \
    expat \
    file \
    findutils \
    flex \
    gawk \
    gcc-6 \
    g++ \
    git \
    libgmp-dev \
    make \
    grep \
    gzip \
    libedit-dev \
    libssh2-1-dev \
    libtool \
    libusb-1.0-0-dev \
    libxml2-dev \
    mpc \
    libmpfr-dev \
    ninja-build \
    libncurses-dev \
    libssl-dev \
    patchelf \
    pkg-config \
    python2.7 \
    sed \
    swig \
    tar \
    texinfo \
    zlib1g-dev \
    zsh

# "make toolchain" expects a binary named "python2"
RUN ln -s /usr/bin/python2.7 /usr/bin/python2

ENV HOME /root
WORKDIR $HOME
RUN mkdir bin

# This is where "rust/x.py install" places the resulting cargo binary
RUN ln -s $HOME/riscv-rust-toolchain/build/x86_64-unknown-linux-gnu/stage0/bin/cargo bin/cargo

RUN git clone https://github.com/riscv-rust/riscv-rust-toolchain.git

WORKDIR $HOME/riscv-rust-toolchain
RUN git submodule update --init --recursive

ENV PATH $HOME/bin:$HOME/riscv-rust-toolchain/toolchain/bin/:$PATH
RUN make toolchain
