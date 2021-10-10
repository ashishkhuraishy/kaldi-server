FROM kaldiasr/kaldi:latest AS base
FROM nginx

LABEL MAINTAINER="Ashish Khuraishy(ashishkhuraishy@gmail.com)"

# Setting up all the packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    g++ make automake \
    autoconf bzip2 unzip \
    wget sox libtool python2.7\
    git subversion python3 \
    zlib1g-dev gfortran ca-certificates \
    patch ffmpeg vim \
    build-essential zlib1g-dev \
    libncurses5-dev libgdbm-dev libnss3-dev \
    libssl-dev libsqlite3-dev libreadline-dev \
    libffi-dev curl libbz2-dev && \
    rm -rf /var/lib/apt/lists/*

# Downloading and setting up kaldi asr
RUN ln -s /usr/bin/python3 /usr/bin/python
COPY --from=base /opt/kaldi /opt/kaldi

# Installing python3.9
RUN wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz &&\
    tar -xf Python-3.9.1.tgz && cd Python-3.9.1 &&\
    ./configure --enable-optimizations && make -j 2 &&\
    make altinstall && ln -sf /usr/bin/python3.9 /usr/bin/python3

WORKDIR /opt/kaldi/
