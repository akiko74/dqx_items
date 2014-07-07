#source 'https://rubygems.org'
source 'http://bundler-api.herokuapp.com'


gem 'rails', '3.2.19'
gem 'rails-i18n'

gem 'mysql2'
gem 'nokogiri'
gem 'devise'
gem 'devise-i18n'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'therubyracer', '~> 0.10.2'
  gem "less-rails"
  gem "twitter-bootstrap-rails"
  gem 'font-awesome-sass'
end


group :test,:development do
  gem 'cucumber-rails', require: false
  gem 'rspec-rails', '~> 2.14.2'
  gem 'net-http-spy',:require => false
  gem 'spork'
  gem 'database_cleaner'
  gem 'rb-fsevent'
  gem 'guard-spork'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'faker-japanese'
  #gem 'email_spec',    :git=>'git://github.com/bmabey/email-spec.git', :branch=>'rails3',:require => false
  gem 'simplecov'
  #gem 'debugger'
end
  gem 'thin'


group :production do
  gem 'unicorn'              ,:require => false
  gem 'astrails-safe'        ,:require => false
  gem 'request-log-analyzer' ,:require => false
  gem "pg"
  gem "heroku"
end

