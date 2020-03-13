FROM ruby:2.6.5-alpine3.11

ARG APP_PATH=app
ARG RAILS_ENV

RUN apk --update add build-base nodejs tzdata 
RUN apk --update add postgresql-dev postgresql-client

ENV INSTALL_PATH /cran_pelago
RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock ./

ENV RACK_ENV=$RAILS_ENV

RUN gem install bundler

ARG RAILS_ENV=production
RUN if [[ "$RAILS_ENV" == "production" ]]; then bundle install --without development test; else bundle install --with development; fi

COPY . ./

CMD ["bundle", "exec", "rails", "s"]
