FROM 0x01be/coin as coin

FROM alpine as builder

RUN apk add --no-cache --virtual lemon-build-dependencies \
    git \
    build-base \
    cmake \
    coreutils \
    bison \
    flex \
    qt5-qtbase-dev \
    qt5-qtdeclarative-dev \
    qt5-qtwayland \
    gmp-dev \
    spdlog-dev

COPY --from=coin /opt/coin/ /opt/coin/

ENV LEMON_VERSION=1.3.1 \
    LD_LIBRARY_PATH=/lib/:/usr/lib:/opt/coin/lib/ \
    DYLD_LIBRARY_PATH=/lib/:/usr/lib:/opt/coin/lib/ \
    C_INCLUDE_PATH=/usr/include/:/opt/coin/include \
    CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}:/opt/coin

ADD http://lemon.cs.elte.hu/pub/sources/lemon-${LEMON_VERSION}.tar.gz /lemon-${LEMON_VERSION}.tar.gz
WORKDIR /
RUN tar xzf lemon-${LEMON_VERSION}.tar.gz

WORKDIR /lemon-${LEMON_VERSION}/build

RUN apk add --no-cache --virtual lemon-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    glpk-dev

RUN apk add --no-cache --virtual lemon-doc-dependencies \
    doxygen \
    graphviz

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/lemon \
    -DCOIN_ROOT_DIR=/opt/coin \
    ..
RUN make
RUN make install 

