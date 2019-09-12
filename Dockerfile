# build last version
# docker build -t wn1980/snowboy .

# compile into local /tmp/snowboy
# docker run -it --rm -v "./src:/data" wn1980/snowboy bash

FROM ubuntu:18.04

ARG SNOWBOY_VERSION="1.3.0"

RUN apt-get update
RUN apt-get install -y \
	make g++ gfortran libtool \
	python3-dev \
	libatlas3-base libatlas-base-dev libblas-dev \
	libpcre3-dev \
	libdpkg-perl

RUN tar xzf swig-3.0.12.tar.gz
RUN cd swig-3.0.12 && \
    ./configure --prefix=/usr \
    --without-clisp  \
    --without-maximum-compile-warnings && \
    make

RUN cd swig-3.0.12 && \
    make install && \
    install -v -m755 -d /usr/share/doc/swig-3.0.12 && \
    cp -v -R Doc/* /usr/share/doc/swig-3.0.12

RUN tar xzf v${SNOWBOY_VERSION}.tar.gz
RUN cd /snowboy-${SNOWBOY_VERSION}/swig/Python3 && make
RUN cd /snowboy-${SNOWBOY_VERSION}/swig/Python3 && python3 -c "import _snowboydetect; print('OK')"

RUN mkdir /data
CMD cp /snowboy-*/swig/Python3/*.so /data
