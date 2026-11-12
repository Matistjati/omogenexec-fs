FROM omogen/common-fs:latest

ARG RUST_VERSION=1.98.1
ARG RUST_SHA256=5326b36c53de11d148c8f8dab6553a3d1006c2cfd32123683073fad3c302605b

RUN apt-get update

# rustc links through the system C toolchain.
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
                    apt-get install -y --no-install-recommends \
                    gcc libc6-dev wget ca-certificates xz-utils

# Ubuntu ships an old rustc, so install the official release into /usr (the sandbox does not mount /usr/local).
RUN wget -q https://static.rust-lang.org/dist/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu.tar.xz -O /tmp/rust.tar.xz && \
    echo "${RUST_SHA256}  /tmp/rust.tar.xz" | sha256sum -c - && \
    tar -xJf /tmp/rust.tar.xz -C /tmp && \
    /tmp/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu/install.sh --prefix=/usr --disable-ldconfig \
        --components=rustc,rust-std-x86_64-unknown-linux-gnu && \
    rm -rf /tmp/rust.tar.xz /tmp/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu

RUN apt-get remove -y wget ca-certificates xz-utils && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
