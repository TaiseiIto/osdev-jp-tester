FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential
RUN apt-get update && apt-get upgrade -y && apt-get install -y git
RUN apt-get update && apt-get upgrade -y && apt-get install -y ruby-full
RUN gem install bundler
WORKDIR /root/
ARG REPOSITORY
RUN git clone --recursive $REPOSITORY osdev-jp
WORKDIR osdev-jp/
ARG BRANCH
RUN git checkout $BRANCH
RUN cat << EOF > Gemfile
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
EOF
RUN bundle install
ARG PORT
EXPOSE $PORT
