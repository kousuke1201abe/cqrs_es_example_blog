FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /app
COPY ./command /app
RUN bundle install

CMD ["bundle", "exec", "ruby", "main.rb"]