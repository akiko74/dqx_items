source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'
gem 'nokogiri'
gem 'devise'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'therubyracer', '~> 0.10.2'
  gem "less-rails"
  gem "twitter-bootstrap-rails"
end


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
end
  gem 'thin'


group :production do
  gem 'unicorn'              ,:require => false
  gem 'astrails-safe'        ,:require => false
  gem 'request-log-analyzer' ,:require => false
  gem "pg"
  gem "heroku"
end

