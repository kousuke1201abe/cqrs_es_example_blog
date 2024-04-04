FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /app
COPY ./read_model_updater/main.rb /app/main.rb
COPY ./read_model_updater/Gemfile /app/Gemfile
COPY ./read_model_updater/Gemfile.lock /app/Gemfile.lock
RUN bundle install

CMD ["bundle", "exec", "ruby", "main.rb"]