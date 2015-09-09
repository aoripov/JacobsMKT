# JacobsMKT

## Dependencies ##
* [mysql](https://www.mysql.com/)
* [ruby-2.2.1](https://www.ruby-lang.org/en/news/2015/03/03/ruby-2-2-1-released/)
* [rails-4.2.1](https://rubygems.org/gems/rails/versions/4.2.1)

## Setting up database ##
Set up mysql database username and password in ```JacobsMKT/config/database.yml```


## Build & Run ##

### Development mode
```sh
$ cd JacobsMKT
$ bundle install
$ rake db:migrate
$ rails server
```
Manually open [http://localhost:3000/](http://localhost:3000/) in your browser.

### Production mode
```sh
$ cd JacobsMKT
$ bundle install
$ RAILS_ENV=production rake db:migrate
$ RAILS_ENV=production rails server
```

## Deployment on [Heroku](https://www.heroku.com/)##
Make sure that ```JacobsMKT/config/database.yml``` contains following lines
```
production:
  url: <%= ENV['DATABASE_URL'] %>
```
so that database details are configured automatically.
