FROM ruby:2.6.3

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -qq && apt-get install -y postgresql-client build-essential libpq-dev nodejs ghostscript

RUN mkdir -p /tiger_api
RUN mkdir -p /usr/local/nvm
WORKDIR /tiger_api

RUN curl -sL https://deb.nodesource.com/setup_10.x — Node.js 10 LTS "Dubnium" | bash -
RUN apt-get install -y nodejs

RUN node -v
RUN npm -v

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock package.json ./
RUN gem install bundler -v 1.17.2
RUN gem install foreman -v 0.85.0
RUN bundle install --verbose 
# --jobs 20 --retry 5

RUN npm install -g yarn
#RUN yarn install --check-files

# Copy the main application.
COPY . ./

RUN yarn install && yarn install --check-files


# RUN rails db:migrate
# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3100

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
#CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0","-e","development","-p","3100"]
