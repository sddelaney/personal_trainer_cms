source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails',      '6.0.2.2'
gem 'puma',       '3.12.2'
gem 'sass-rails', '5.1.0'
gem 'webpacker',  '4.0.7'
gem 'turbolinks', '5.2.0'
gem 'jbuilder',   '2.9.1'
gem 'bootsnap',   '1.4.5', require: false
gem 'omniauth-auth0', '~> 2.2'
gem 'dotenv-rails'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'sassc-rails', '>= 2.1.0'
gem 'jquery-rails'
gem 'twilio-ruby'
gem 'bulma-rails'
gem 'rails_12factor', group: :production
gem 'devise'
gem 'cancancan'
gem 'rails_admin', '~> 2.0'
gem 'google-apis-slides_v1', '~> 0.2.0'
gem 'google-apis-drive_v3'
gem 'google-api-client'
gem 'simple_form'
gem 'activerecord-session_store'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'

group :development, :test do
  gem 'sqlite3', '1.4.1'
  gem 'whenever', require: false
  gem 'better_errors'
  gem 'byebug',  '11.0.1', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console',           '4.0.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'

  gem "binding_of_caller"
end

group :test do
  gem 'capybara',           '3.28.0'
  gem 'selenium-webdriver', '3.142.4'
  gem 'webdrivers',         '4.1.2'
end

group :production do
  gem 'pg', '1.1.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
