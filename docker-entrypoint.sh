#!/bin/bash
set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle install
if [[ $APP_ENV == "production" ]]; then
  bundle exec rails s -b 0.0.0.0 -p 3000 -e $APP_ENV
elif [[ $APP_DEBUG == "true" ]]; then
  WEB_CONCURRENCY=0 RAILS_MAX_THREADS=1 bundle exec rdebug-ide --debug --host 0.0.0.0 --port 1234 -- bin/rails s -b 0.0.0.0 -p 3000
else
  bundle exec rails s -b 0.0.0.0 -p 3000
fi