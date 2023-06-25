source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.0.4", ">= 7.0.4.3"

gem "bootsnap", require: false
gem "email_validator", "~> 2.2.4"
gem "importmap-rails", "~> 1.1.6"
gem "money-rails", "~>1.15"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "redis", "~> 4.0"
gem "sprockets-rails", "~> 3.4.2"
gem "stimulus-rails", "~> 1.2.1"
gem "tailwindcss-rails", "~> 2.0.29"
gem "turbo-rails", "~> 1.4.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara", "~> 3.39.1"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.2"
  gem "selenium-webdriver", "~> 4.9.0"
  gem "shoulda-matchers", "~> 5.3"
end
