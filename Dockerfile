FROM ruby:latest
WORKDIR /app

# Enable YJIT by default
ENV RUBY_YJIT_ENABLE=true

RUN apk add --no-cache --update \
    build-base libffi-dev tzdata postgresql-client postgresql-dev bash git nodejs npm yarn gcompat

COPY . .

RUN gem install bundler
RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
