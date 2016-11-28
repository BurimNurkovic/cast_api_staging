ruby '2.2.5'
source 'https://rubygems.org'

gem 'rails', '4.2'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'active_model_serializers'
gem 'devise'
gem 'virtus'
gem 'puma'
gem 'barometer'
gem 'parse-ruby-client'
gem 'activeadmin', github: 'activeadmin'
gem 'koala'
gem 'httparty'
gem 'delayed_job_active_record'
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'aws-sdk', '< 2.0'
gem 'mandrill-api'
gem 'ckeditor'
gem 'kaminari'
gem 'validate_url'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'newrelic_rpm'
gem 'timezone', '~> 1.0'
gem 'wunderground'
gem 'http'
gem 'sanitize'

# Amazon Product Advertising API in Ruby
gem 'vacuum', '~> 1.4.0'

# Adapter to memcached
gem 'dalli', '~> 2.7.6'

group :production, :staging do
  gem 'rails_12factor'
end

group :test, :development do
  # gem 'debugger'
  gem 'rspec-rails', '~> 3.4.2'
  gem 'rspec-collection_matchers'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'factory_girl_rails', '~> 4.7.0'
  gem 'awesome_print', '~> 1.6.1'
  gem 'foreman', '~> 0.81.0'
  gem 'dotenv-rails', '~> 2.1.1'
  gem 'guard-rspec', '~> 4.7.0', require: false
  gem 'pry-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'byebug'
end

group :test do
  # gem 'simplecov', require: false
  gem 'webmock', '~> 2.0.2', require: false
  # TODO: [README] Beware that sometimes specs can be not passing cause of VCR retracking,
  # so ensure it's not the problem in first place when specs are failing
  gem 'vcr', '~> 3.0.1'
  gem 'shoulda-matchers', '~> 3.1'
end
