FROM progrium/buildstep:latest
MAINTAINER david.siaw@mobingi.com

RUN apt-get update
RUN apt-get install -y supervisor libsqlite3-dev
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config /config
COPY sudoers /etc/sudoers

ADD run.sh /run.sh
ADD startup.sh /startup.sh
RUN rm -fr /app

RUN chmod 755 /*.sh

ENV GIT_REPO /code
ENV PORT 8080

EXPOSE 80
CMD ["/run.sh"]
