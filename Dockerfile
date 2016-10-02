FROM resin/rpi-raspbian
MAINTAINER George Shih <georgezero@trove.nyc>

ENV SYNCTHING_VERSION=0.14.7

RUN apt-get update \
 && apt-get install -y --no-install-recommends apache2-utils ca-certificates curl xmlstarlet \
 && apt-get install -y --no-install-recommends vim zsh git rsync unzip python3 gnupg \
 && curl -s https://syncthing.net/release-key.txt | apt-key add - \
 && echo "deb http://apt.syncthing.net/ syncthing release" > /etc/apt/sources.list.d/syncthing-release.list \
 && apt-get update -o Dir::Etc::sourcelist="sources.list.d/syncthing-release.list" \
 && apt-get install -y syncthing=$SYNCTHING_VERSION \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf" \
  && curl -o /usr/local/bin/gosu.asc -L "https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf.asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

VOLUME /syncthing/config
VOLUME /syncthing/data

#RUN adduser --disabled-password --gecos '' george && adduser george sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#USER george
RUN groupadd george
RUN useradd --no-create-home -g george george
ADD start.sh /
CMD sudo /start.sh
# entry creates non-root user, and runs start.sh
#ADD entry.sh /
#CMD /entry.sh

#ENV UID=1027

