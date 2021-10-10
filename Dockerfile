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
RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi && \
    cd /opt/kaldi/tools && \
    ./extras/install_mkl.sh && \
    make -j $(nproc) && \
    cd /opt/kaldi/src && \
    ./configure --shared && \
    make depend -j $(nproc) && \
    make -j $(nproc) && \
    find /opt/kaldi  -type f \( -name "*.o" -o -name "*.la" -o -name "*.a" \) -exec rm {} \; && \
    find /opt/intel -type f -name "*.a" -exec rm {} \; && \
    find /opt/intel -type f -regex '.*\(_mc.?\|_mic\|_thread\|_ilp64\)\.so' -exec rm {} \; && \
    rm -rf /opt/kaldi/.git

# Installing python3.9
RUN wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz &&\
    tar -xf Python-3.9.1.tgz && cd Python-3.9.1 &&\
    ./configure --enable-optimizations && make -j 2 &&\
    make altinstall && ln -sf /usr/bin/python3.9 /usr/bin/python3

WORKDIR /opt/kaldi/
