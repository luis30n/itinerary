FROM ruby:3.3.6

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

COPY . .
