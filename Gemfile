#source 'http://rubygems.org'
source 'http://production.s3.rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.13'

gem 'nokogiri'
gem 'devise'
gem 'mechanize'
gem 'headless'
gem 'selenium-webdriver'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'jquery-rails'
end

gem 'therubyracer', '~> 0.10.2'
gem "less-rails"
gem "twitter-bootstrap-rails"

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'mysql2'

group :test,:development do
  # Net::HTTPデバック用 環境変数HTTP_SPY=1を設定すると有効化
  gem 'cucumber-rails', require: false
  gem 'rspec-rails','>= 2.13.0'
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
  gem 'debugger'
  gem 'thin'
  gem 'capybara'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'guard-jasmine'
  gem 'sinon-rails'
end


group :production do
  gem 'unicorn'              ,:require => false
  gem 'astrails-safe'        ,:require => false
  gem 'request-log-analyzer' ,:require => false
end

