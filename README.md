# README

Install the gems by executing following command.

```bash
bundle install
```

Create config/database.yml file if not present. Example template is given below

```bash
# SQLite. Versions 3.8.0 and up are supported.
#   gem install sqlite3
#
#   Ensure the SQLite 3 gem is defined in your Gemfile
#   gem "sqlite3"
#
default: &default
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
  database: db/production.sqlite3
```

Run migrations by executing the following command

```bash
rails db:migrate
```

Create database by executing the following command

```bash
rails db:create
```

Run tests by executing following command.

```bash
rails test -v
```

