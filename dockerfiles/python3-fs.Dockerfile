FROM omogen/common-fs:latest

RUN apt-get update

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget bzip2 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.python.org/pypy/pypy3.11-v7.3.20-linux64.tar.bz2 -O /tmp/pypy.tar.bz2 && \
    tar -xjf /tmp/pypy.tar.bz2 -C /opt/ && \
    ln -s /opt/pypy3.11-v7.3.20-linux64/bin/pypy3 /usr/bin/pypy3 && \
    rm /tmp/pypy.tar.bz2

RUN apt-get remove -y wget bzip2 ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
