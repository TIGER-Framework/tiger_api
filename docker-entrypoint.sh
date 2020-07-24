#!/bin/sh

set -e 
if [ -f /tiger_rest/tmp/pids/server.pid ]
then
  rm /tiger_rest/tmp/pids/server.pid 
fi
rails db:create
rails db:migrate
bundle exec rails server -b 0.0.0.0 -e development -p 3100
#exec bundle exec "$@"
