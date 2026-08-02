FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential
RUN apt-get update && apt-get upgrade -y && apt-get install -y git
RUN apt-get update && apt-get upgrade -y && apt-get install -y ruby-full
RUN apt-get update && apt-get upgrade -y && apt-get install -y tmux
RUN apt-get update && apt-get upgrade -y && apt-get install -y vim
COPY .tmux.conf /root/
COPY .vimrc /root/
RUN gem install bundler
WORKDIR /root/
EXPOSE 4000
ARG REPOSITORY
RUN git clone $REPOSITORY osdev-jp
WORKDIR osdev-jp/
ARG BRANCH
RUN git checkout $BRANCH
RUN cat << EOF > Gemfile
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
EOF
RUN bundle install
