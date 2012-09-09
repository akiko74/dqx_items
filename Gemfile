source 'https://rubygems.org'

gem 'rails', '3.2.8'


gem 'mysql2'
gem 'nokogiri'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'therubyracer'
  gem "twitter-bootstrap-rails"
end


group :test,:development do
  # Net::HTTPデバック用 環境変数HTTP_SPY=1を設定すると有効化
  gem 'cucumber-rails', require: false
  gem 'rspec-rails'   ,:git => 'git://github.com/rspec/rspec-rails.git'
  gem 'net-http-spy',:require => false
  gem 'spork'
  gem 'database_cleaner'
  gem 'rb-fsevent'
  gem 'guard-spork'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'faker-japanese'
  gem 'email_spec',    :git=>'git://github.com/bmabey/email-spec.git', :branch=>'rails3',:require => false
  gem 'simplecov'
  gem 'debugger'
end


group :production do
#  Use unicorn as the web server
  gem 'unicorn'              ,:require => false
  gem 'capistrano'           ,:require => false
  gem 'astrails-safe'        ,:require => false
  gem 'request-log-analyzer' ,:require => false
  gem "pg"
#  gem 'therubyracer-heroku'
  gem "heroku"
end

