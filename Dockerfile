# based on https://hub.docker.com/r/itherz/exim4/~/dockerfile/
# based on https://github.com/tianon/dockerfiles/blob/master/exim4/Dockerfile

FROM debian:stable-slim
MAINTAINER Claas Lisowski <https://github.com/blacs30/docker-protonmail-personal-gateway>
ARG TARGETPLATFORM
# grab tini for signal processing and zombie killing
ENV TINI_VERSION v0.18.0
ADD gpgit.pl /usr/local/bin/gpgit.pl
RUN apt-get update && apt-get install -y iproute2 net-tools gpg curl libmail-gnupg-perl exim4-daemon-light && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install ca-certificates && c_rehash && rm -rf /var/lib/apt/lists/*
RUN set -x \
&& mkdir -p  /usr/local/bin/ \
  && curl -L https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-$TARGETPLATFORM  -o /usr/local/bin/tini
RUN curl -L https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-$TARGETPLATFORM.asc -o /usr/local/bin/tini.asc \
&& gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
&& gpg --verify /usr/local/bin/tini.asc \
&& chmod +x /usr/local/bin/tini \
&& /usr/local/bin/tini -h

# ADD rsyslog.conf /etc/rsyslog.conf
ADD set-exim4-update-conf /usr/local/bin/
ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/set-exim4-update-conf /usr/local/bin/gpgit.pl

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 25
CMD ["/usr/local/bin/tini", "--", "exim", "-bdf", "-v", "-q30m"]
