FROM ruby:3.0.2

ARG APP_PATH=/home/docker/app
ARG USER=docker
ARG PW=docker
ARG UID
ARG GID
ARG APP_DATABASE_PASSWORD
ENV APP_DATABASE_PASSWORD=${APP_DATABASE_PASSWORD}

RUN gem install rails -v 6.1

# add user
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | chpasswd

RUN mkdir ${APP_PATH}
RUN chown ${UID}:${GID} ${APP_PATH}
COPY --chown=${UID}:${GID} ./ ${APP_PATH}

WORKDIR ${APP_PATH}
RUN chmod a+x ${APP_PATH}/docker-entrypoint.sh

USER ${UID}:${GID}

RUN bundle config set --local path './vendor/bundler'

EXPOSE 3000
CMD [ "./docker-entrypoint.sh" ]