# README

### Setup

1. Clone this repo.
2. `$ bundle install`
3. `$ rails db:create db:migrate db:seed` creates, migrates, and seeds initial records. Check out `/db` for those files.
4. `$ bundle exec rspec` runs tests and verifies everything working well.

Note: `rails` is an alias for `rake` within Rails 5+ projects. You can also run these tasks individually, like `$rails db:create` then `rails db:migrate`, etc. if you want to see output more slowly.
