# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3' # degraded . cause it's relied package libv8 and el capitan has known problem.
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'chartjs-ror'
gem 'nokogiri', '~> 1.10.4'
gem 'rails', '~> 6.0.0.rc2'
gem 'railties', '~> 6.0.0.rc2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'brakeman'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 5.0'
  gem 'pry-byebug'
  gem 'puma'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '~> 3.3.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper' # not recommended from 2019/03/31.
  # Capybara will meets Error. use webdrivers instead of chromedriver-herlper
  gem 'webdrivers'
end
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'activerecord-import', '~> 1.0.3'
gem 'bcrypt', '~> 3.1.7'
gem 'devise', '4.7.1'
gem 'dotenv-rails'
gem 'faraday'
gem 'mechanize'
gem "omniauth"
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
gem 'pry-rails'
gem 'rails_12factor', group: :production
gem 'webpacker', '~> 4.0.7'
