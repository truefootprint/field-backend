source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "rails", "~> 6.0.0"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.3"
gem "rack-cors", "~> 1.0.3"
gem "unitwise", "~> 2.2"
gem "attr_encrypted", "~> 3.1"
gem "blind_index", "~> 1.0"
gem "mobility", "~> 0.8"
gem 'jbuilder'

group :development, :test do
	gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-byebug'
  gem "rspec-rails", "~> 3.8.2"
  gem "factory_bot_rails", "~> 5.0.2"
  gem "pry-rails", "~> 0.3.9"
end
