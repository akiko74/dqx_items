#source 'https://rubygems.org'
source 'http://bundler-api.herokuapp.com'


ruby '2.1.2'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-sass', '~> 4.2.0'
gem 'nokogiri'
gem 'devise'
gem 'mechanize'
gem 'headless'
gem 'selenium-webdriver'
gem 'rails-i18n'
gem 'devise-i18n'
gem 'simple_form'

gem 'puma'

gem 'backbone-on-rails'
gem 'marionette-rails', '~> 2.2.1'
gem 'twitter-typeahead-rails', '~> 0.10.5'




group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'mysql2'

group :test,:development do
  # Net::HTTPデバック用 環境変数HTTP_SPY=1を設定すると有効化
  gem 'cucumber-rails', require: false
  gem 'rspec-rails','~> 3.0.1'
  gem 'net-http-spy',:require => false
  gem 'database_cleaner'
  gem 'rb-fsevent'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'faker-japanese'
  #gem 'email_spec',    :git=>'git://github.com/bmabey/email-spec.git', :branch=>'rails3',:require => false
  gem 'simplecov'
  gem 'capybara'
#  gem 'jasmine'
#  gem 'jasminerice'
#  gem 'guard-jasmine'
#  gem 'sinon-rails'
  gem 'jasmine-rails'
end


group :production do
  gem 'astrails-safe'        ,:require => false
  gem 'request-log-analyzer' ,:require => false
  gem 'rails_12factor'
end


