FROM ruby:2.7.2
WORKDIR /build
EXPOSE 9292

COPY Gemfile* ./
RUN bundle install

COPY . .
ENTRYPOINT [ "./docker-entrypoint.sh" ]