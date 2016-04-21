FROM westonplatter/ruby-nodejs-postgres:2.3.0

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    libxslt-dev \
    libxml2-dev \
    nodejs \
    locales

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

# RUN bundle install
RUN gem install bundler && bundle install --jobs 20 --retry 5

ADD . /app
