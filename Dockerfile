FROM 0x01be/lemon:build as build
FROM 0x01be/coin as coin

FROM alpine as builder

RUN apk add --no-cache --virtual lemon-runtime-dependencies \
    qt5-qtbase \
    qt5-qtdeclarative \
    qt5-qtwayland \
    gmp \
    spdlog &&\
    apk add --no-cache --virtual openroad-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    glpk-dev

COPY --from=build /opt/lemon/ /opt/lemon/
COPY --from=coin /opt/coin/ /opt/coin/

ENV LEMON_VERSION=1.3.1 \
    LD_LIBRARY_PATH=/lib/:/usr/lib:/opt/coin/lib/:/opt/lemon/lib/ \
    DYLD_LIBRARY_PATH=/lib/:/usr/lib:/opt/coin/lib/:/opt/lemon/lib/ \
    C_INCLUDE_PATH=/usr/include/:/opt/coin/include/:/opt/lemon/include/ \
    PATH=${PATH}:/opt/coin/bin/:/opt/lemon/bin/

