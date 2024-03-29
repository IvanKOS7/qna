source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.5.3'

gem 'rails', '~> 5.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim-rails'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'devise'
gem "bootstrap"
gem 'jquery-rails'
#gem 'aws-sdk-s3', require: false
gem 'rack-cors'
gem 'cocoon'
gem 'with_model'
gem 'omniauth'
gem 'omniauth-github'
gem "omniauth-rails_csrf_protection"
gem 'omniauth-vkontakte'
gem "omniauth-yandex", :github => '/evrone/omniauth-yandex', branch: 'dependabot/bundler/omniauth-2.1.0'
gem 'cancancan'
gem 'doorkeeper'
#Serializer
gem 'active_model_serializers'
gem 'oj'
##########
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'aasm'
gem 'mysql2'
gem 'jdbc-mysql',      '~> 5.1.35', :platform => :jruby
gem 'thinking-sphinx', '~> 5.3'
gem 'rubocop-rails', require: false
gem 'mini_racer'
gem 'unicorn'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'action-cable-testing'
  gem 'faker'
  gem 'database_cleaner'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
