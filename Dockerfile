FROM ruby

ARG ENVIRONMENT=

RUN apt update && \
    apt install ruby-dev gem bundler ruby-bundler make gcc libmysqlclient-dev libmysql++-dev

WORKDIR /app

COPY . /app

ENV ENVIRONMENT=${ENVIRONMENT:-production}

RUN bundler install && rake db:schema:load RACK_ENV=${ENVIRONMENT}

CMD ["bundle", "exec", "puma", "config.ru", "-C", "puma.rb"]
