FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y git
WORKDIR /root/
ARG REPOSITORY
RUN git clone $REPOSITORY osdev-jp
WORKDIR osdev-jp/
ARG BRANCH
RUN git checkout $BRANCH
