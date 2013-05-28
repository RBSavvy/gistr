#!/bin/bash -x -e

if [[ "$TRAVIS_PULL_REQUEST" == "true" ]]; then
  echo "This is a pull request. No deployment will be done.";
  exit 0;
fi

if [[ "$TRAVIS_BRANCH" != "master" ]] || [[ "$TRAVIS_BRANCH" != "staging" ]]; then
  echo "This is not a deployable branch.";
  exit 0;
fi

if [[ "x$HEROKU_API_KEY" == "x" ]]; then
  echo "Missing Heroku API Key.";
  exit 1;
fi

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
heroku plugins:install https://github.com/ddollar/heroku-anvil


if [[ "$TRAVIS_BRANCH" == "master" ]]; then
  heroku build -r gistr -b https://github.com/heroku/heroku-buildpack-ruby.git
fi

# If we ever add a staging
# if [[ "$TRAVIS_BRANCH" == "staging" ]]; then
#   heroku build -r gistr-staging -b https://github.com/heroku/heroku-buildpack-ruby.git
# fi