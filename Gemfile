source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# Essentials
gem "bootsnap", ">= 1.4.2", require: false
gem "jbuilder", "~> 2.7"
gem "puma", "~> 4.3"
gem "rails", "~> 6.0.2", ">= 6.0.2.1"

# Frontend
gem "turbolinks", "~> 5"

# Backend
gem "active_model_serializers", "~> 0.10.0"
gem "daemons"
gem "delayed_job_active_record"
gem "httparty"

# Database Related
gem "activerecord-import"
gem "pg"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "pry"
  gem "pry-byebug"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "awesome_print"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "ffaker"
  gem "vcr"
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
