FROM ubuntu:bionic

MAINTAINER Judzhin Miles <info[woof-woof]msbios.com>

RUN apt-get update && apt-get install -y cowsay \
    && ln -s /usr/games/cowsay /usr/bin/cowsay

ENTRYPOINT ["cowsay"]