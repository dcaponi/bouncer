FROM ruby:2.6

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim \
  yarn

COPY Gemfile* /usr/src/bouncer/
WORKDIR /usr/src/bouncer
RUN bundle install

COPY . /usr/src/bouncer

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["rails", "s", "-b", "0.0.0.0"]
