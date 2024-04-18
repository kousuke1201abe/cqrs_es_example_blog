FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /app
COPY ./client/main.rb /app/main.rb
COPY ./client/pages /app/pages
COPY ./client/Gemfile /app/Gemfile
COPY ./client/Gemfile.lock /app/Gemfile.lock
RUN bundle install

CMD ["bundle", "exec", "ruby", "main.rb"]