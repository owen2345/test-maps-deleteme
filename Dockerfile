FROM ruby:2.7.1 AS builder

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# Install nodejs + yarn
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs  yarn

RUN mkdir /app
RUN mkdir /app/frontend
WORKDIR /app

# backend
COPY Gemfile.lock Gemfile /app/
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without development test

# frontend
ADD frontend/package.json frontend/yarn.lock /app/frontend/
RUN cd frontend && yarn install --check-files --network-timeout 100000

COPY . /app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

## Development
FROM builder AS development
RUN bundle config set with 'development test'
RUN bundle install --jobs 20 --retry 5
# cypress dependencies
RUN apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb

## Production
FROM builder AS production
RUN cd frontend && yarn build