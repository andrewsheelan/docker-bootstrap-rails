# docker-bootstrap-rails
Simple dev bootstrap rails with docker-compose. You'll be up and running as quickly as 1..2...3!

# Requirements:
- docker
- docker-compose
- Mac (kidding.. tested on a mac, let me know if it doesnt work for you)

# Clone repo and run using command:
```
wget -O /tmp/z.$$ https://github.com/andrewsheelan/docker-bootstrap-rails/archive/refs/heads/master.zip && 
   unzip -d . /tmp/z.$$ &&
   rm /tmp/z.$$
cd docker-bootstrap-rails-master
./bootstrap
```

Goto http://localhost:3000

| File | Description |
| --- | --- |
| docker-compose.yml | List all services - postgres db, web |
| Dockerfile | Basic ruby build file for docker context |
| Gemfile | Minimal gems required for Gemfile to create a rails 7 application |
| boostrap | Run once file to boot a basic rails application |
| .dockerignore | Ignore tmp |


## File: docker-compose.yml
```yaml
version: "3.9"
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: password
      POSTGRES_HOST_AUTH_METHOD: trust
  web:
    build: .
    volumes:
      - .:/app
      - ./tmp/bundle:/bundle
    command: bash -c "rm -f tmp/pids/server.pid && bin/rails tailwindcss:watch && rails server -b '0.0.0.0'"
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://dev:password@db
      BUNDLE_PATH:  /bundle
    depends_on:
      - db
```

## File: Dockerfile
```Dockerfile
FROM ruby:3.1.1
WORKDIR /app

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
COPY . .

RUN gem install bundler
RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## File: Gemfile
```Gemfile
source "https://rubygems.org"

ruby "3.1.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2", ">= 7.0.2.3"
```

## File: bootstrap
```bash
#!/bin/bash

# Force a build
touch Gemfile.lock && docker-compose build

# Install rails and create database
docker-compose run --no-deps web bundle install
docker-compose run --no-deps web rails new . --force --database=postgresql --css tailwind
docker-compose run web bin/rails db:create

# Remove this file
rm bootstrap

# Start the application
docker-compose up
```

## File: .dockerignore
```
# Ignore tmp
/tmp/*
```
