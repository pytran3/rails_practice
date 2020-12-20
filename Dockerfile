FROM ruby:2.6.5
ENV RUBYOPT -EUTF-8

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
