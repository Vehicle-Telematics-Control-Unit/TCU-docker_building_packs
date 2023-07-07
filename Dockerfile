FROM alpine:3.17.2 AS builder

LABEL description="Build vsomeip-boost"

# Boost-build
ARG BOOST_VERSION=1.63.0
ARG BOOST_DIR=boost_1_63_0
ENV BOOST_VERSION ${BOOST_VERSION}

RUN apk add --no-cache --virtual .build-dependencies \
    openssl \
    linux-headers \
    build-base 
RUN wget http://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION}/${BOOST_DIR}.tar.bz2 

RUN tar --bzip2 -xf ${BOOST_DIR}.tar.bz2 \
    && cd ${BOOST_DIR} \
    && ./bootstrap.sh \
    && ./b2 --without-python --prefix=/usr -j $(echo $(nproc --all) | grep -o '[0-9]*') link=shared runtime-link=shared install \
    && cd .. && rm -rf ${BOOST_DIR} ${BOOST_DIR}.tar.bz2 \
    && apk del .build-dependencies

# vsomeip-build
COPY vsomeip vsomeip

RUN apk update && apk add --no-cache --virtual .second_build_dependency \
    binutils cmake curl gcc g++ git libtool make tar build-base linux-headers

RUN cd vsomeip; \
     rm -rf build; \
     mkdir build; \
     cd build; \
     cmake .. ; \
     ls ; \
     make -j $(echo $(nproc --all) | grep -o '[0-9]*'); \
     make install;

RUN rm -rf /vsomeip
RUN apk del .second_build_dependency
