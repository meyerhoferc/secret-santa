# README

### Setup

1. Clone this repo.
2. `$ bundle install`
3. `$ rails db:create db:migrate db:seed` creates, migrates, and seeds initial records. Check out `/db` for those files.
4. `$ bundle exec rspec` runs tests and verifies everything working well.
5. `$ rails s` and navigate to 127.0.0.1:3000 to see welcome page.

Note: `rails` is an alias for `rake` within Rails 5+ projects. You can also run these tasks individually, like `$rails db:create` then `rails db:migrate`, etc. if you want to see output more slowly.

### Deployment steps

`ssh` into server.
* `git pull` in `secret-santa` folder.
* Install gems: `bundle install`
* Migrate db: `RAILS_ENV=production rails db:migrate`
* Precompile assets: `RAILS_ENV=production rails assets:precompile`
* Clean assets: `RAILS_ENV=production rails assets:clean`
* Restart application: `sudo systemctl restart rails.service`
* If needed, restart nginx: `sudo service nginx restart`
