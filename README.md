- Simple dev bootstrap rails with docker-compose. You'll be up and running as quickly as 1..2...3!

[Source Code](https://github.com/andrewsheelan/docker-bootstrap-rails)

# Requirements
- docker
- docker-compose

# Get started

## Unix/Mac

For Importmaps/tailwind css version

```
wget -O /tmp/z.$$ https://github.com/andrewsheelan/docker-bootstrap-rails/archive/refs/heads/master.zip && 
   unzip -d . /tmp/z.$$ &&
   rm /tmp/z.$$

# Rename this folder if needed
cd docker-bootstrap-rails-master

./bootstrap
```

For esbuild/bootstrap css version

```
wget -O /tmp/z.$$ https://github.com/andrewsheelan/docker-bootstrap-rails/archive/refs/heads/esbuild.zip && 
   unzip -d . /tmp/z.$$ &&
   rm /tmp/z.$$

# Rename this folder if needed
cd docker-bootstrap-rails-esbuild

./bootstrap
```

For esbuild/bootstrap/sidekiq/activeadmin version

```
wget -O /tmp/z.$$ https://github.com/andrewsheelan/docker-bootstrap-rails/archive/refs/heads/sidekiq.zip && 
   unzip -d . /tmp/z.$$ &&
   rm /tmp/z.$$

# Rename this folder if needed
cd docker-bootstrap-rails-sidekiq

./bootstrap
```

## windows (run the bootstrap file commands)

- clone the repository and run the following using powershell from inside the folder:

```
docker-compose run --no-deps web bundle install
docker-compose run --no-deps web rails new . --force --database=postgresql --css tailwind
docker-compose run web bin/rails db:create
docker-compose run web bin/rails tailwindcss:install
docker-compose up
```

Goto [http://localhost:3000](http://localhost:3000)

# Files

| File | Description |
| --- | --- |
| docker-compose.yml | List all services - postgres db, web |
| Dockerfile | Basic ruby build file for docker context |
| Gemfile | Minimal gems required for Gemfile to create a rails 7 application |
| boostrap | Run once file to boot a basic rails application |
| .dockerignore | Ignore tmp |
| bin/docker.dev | Loads Procfile.docker.dev instead of Procfile.dev (copy of dev but without altering the original file)|
| Procfile.docker.dev | Allows 0.0.0.0 host and removes any previous pids on server start |

## docker-compose.yml

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
    command: bin/docker.dev
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://dev:password@db
      BUNDLE_PATH:  /bundle
    depends_on:
      - db
    # tty: true
    stdin_open: true
```

## Dockerfile

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

## Gemfile

```ruby
source "https://rubygems.org"

ruby "3.1.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2", ">= 7.0.2.3"
```

## bootstrap

```bash
#!/bin/bash

# clone the repo and run:
# ./boostrap
# This is a one time only run file

# Force a build
touch Gemfile.lock && docker-compose build

# Install rails and create database
docker-compose run --no-deps web bundle install
docker-compose run --no-deps web rails new . --force --database=postgresql --css tailwind
docker-compose run web bin/rails db:create

# Install tailwind (skip if needed) More Info: https://tailwindcss.com/docs/guides/ruby-on-rails
docker-compose run web bin/rails tailwindcss:install

# Remove this file
rm bootstrap

# Start the application
docker-compose up
```

## .dockerignore

```
# Ignore tmp
/tmp/*
```

## bin/docker.dev

```
#!/usr/bin/env bash

if ! command -v foreman &> /dev/null
then
  echo "Installing foreman..."
  gem install foreman
fi

foreman start -f Procfile.docker.dev
```

## Procfile.docker.dev

```
web: bash -c "rm -f tmp/pids/server.pid && rails server -b '0.0.0.0' -p 3000"
css: bin/rails tailwindcss:watch
```
