source 'https://rubygems.org'

gem 'haml-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'rails', '4.2.4'
gem 'turbolinks'
gem 'jquery-rails'
gem 'puma'
gem 'figaro'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'maestrano-connector-rails'
gem 'config'
gem 'attr_encrypted', '~> 1.4.0'
gem 'sinatra', require: nil
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'slim'
gem 'basecrm'
gem 'omniauth-base', '~> 0.0.1'
gem 'pry-rails'

group :production, :uat do
  gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby
  gem 'pg', platforms: :ruby
  gem 'rails_12factor'
end

group :test, :develpment do
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'sqlite3', platforms: :ruby
end

group :test do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'timecop'
end
