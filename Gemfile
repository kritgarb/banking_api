source "https://rubygems.org"

ruby "3.2.8"
gem "logger"
gem "rails", "~> 7.1.0" 
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "sidekiq"
gem "redis"
gem "bootsnap", ">= 1.4.4", require: false
gem "rack-cors"
gem "cpf_cnpj"
gem "kaminari"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end