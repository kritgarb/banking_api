require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BankingApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Brasilia'
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Authorization']
      end
    end
  end
end