FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
CMD puma -C config/puma.rb
EXPOSE 7770
