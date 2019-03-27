FROM alpine:latest as verilator_build
ARG VERILATOR_VERSION=4.012
ENV VERILATOR_ARCHIVE=/tmp/verilator.tgz
ENV VERILATOR_DIRECTORY=/tmp/verilator-${VERILATOR_VERSION}
RUN apk --no-cache add ca-certificates wget make autoconf g++ flex flex-dev bison
RUN wget -O ${VERILATOR_ARCHIVE} https://www.veripool.org/ftp/verilator-${VERILATOR_VERSION}.tgz
RUN tar x -C /tmp -zf ${VERILATOR_ARCHIVE}
RUN cd ${VERILATOR_DIRECTORY} && \
    ./configure && make && \
    make install -j4


FROM openjdk:8-jre-alpine as sbt_build
ARG SBT_VERSION=1.2.8
ENV SBT_PATH /usr/local/sbt
ENV SBT_URL=https://piccolo.link/sbt-${SBT_VERSION}.tgz
ENV SBT_IVY_CACHE=/usr/local/ivy_cache
ENV PATH ${PATH}:${SBT_PATH}/bin
RUN apk add --no-cache --update bash wget && mkdir -p "${SBT_PATH}" && \
    wget -qO - ${SBT_URL} | tar xz -C ${SBT_PATH} --strip-components=1 && \
    mkdir -p ${SBT_IVY_CACHE} && mkdir -p /usr/local/etc && \
    echo "-J-Dsbt.boot.directory=${SBT_IVY_CACHE}/sbt" > /usr/local/etc/sbtopts && \
    echo "-J-Dsbt.ivy.home=${SBT_IVY_CACHE}/ivy" >> /usr/local/etc/sbtopts
RUN sbt exit



FROM openjdk:8-jre-alpine

RUN apk --no-cache add bash

COPY --from=verilator_build /usr/local/bin/verilator /usr/local/bin/verilator
COPY --from=verilator_build /usr/local/share/man/man1/verilator* /usr/local/share/man/man1/

ENV PATH ${PATH}:/usr/local/sbt/bin
COPY --from=sbt_build ${SBT_IVY_CACHE} ${SBT_IVY_CACHE}
COPY --from=sbt_build /usr/local/sbt /usr/local/sbt
