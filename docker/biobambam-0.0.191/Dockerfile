FROM python:2.7.14
# debian 8.9

LABEL maintainer="fujino@edu.k.u-tokyo.a.jp"

RUN echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org stretch/updates main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install -y dpkg-dev gcc g++ libc6-dev make patch tar unzip && \
    \
    mkdir -p /tools && \
    \
    cd /tools && \
    echo "build libmaus-0.0.196" && \
    wget https://github.com/gt1/libmaus/archive/0.0.196-release-20150326095654.tar.gz && \
    tar xzvf 0.0.196-release-20150326095654.tar.gz && \
    rm -f 0.0.196-release-20150326095654.tar.gz && \
    cd libmaus-0.0.196-release-20150326095654 && \
    autoreconf -i -f && \
    ./configure && \
    make && \
    make install && \
    \ 
    cd /tools && \
    echo "build biobambam-0.0.191" && \
    wget -nc https://github.com/gt1/biobambam/archive/0.0.191-release-20150401083643.tar.gz && \
    tar xzvf 0.0.191-release-20150401083643.tar.gz && \
    rm -f 0.0.191-release-20150401083643.tar.gz && \
    cd biobambam-0.0.191-release-20150401083643 && \
    autoreconf -i -f && \
    ./configure && \
    make && \
    make install && \
    \ 
    echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /root/.bashrc

CMD ["/bin/bash"]
