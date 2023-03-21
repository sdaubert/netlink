# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in netlink.gemspec
gemspec

group :development do
gem 'awesome_print'
  gem 'debase', '~>0.2'
  gem 'ruby-debug-ide', '~> 0.7'
  gem 'solargraph', '~>0.22', require: false
  gem 'yard', '~>0.9', require: false
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'rake'
end

group :rubocop do
  gem 'rubocop', '~> 1.0', require: false
  gem 'rubocop-performance', '~> 1.0', require: false
  gem 'rubocop-rake', '~> 0.6', require: false
end
