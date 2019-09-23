FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir /jetbase-rails

WORKDIR /jetbase-rails

COPY Gemfile* /jetbase-rails/

RUN gem install bundle

RUN bundle install 

COPY . /jetbase-rails

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 5000

CMD ["rails", "server", "-b", "0.0.0.0"]

