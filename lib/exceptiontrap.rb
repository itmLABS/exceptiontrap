require 'net/http'
require 'net/https'
require 'uri'

require 'exceptiontrap/version'
require 'exceptiontrap/config'
require 'exceptiontrap/notifier'
require 'exceptiontrap/rack'

# Use Rack Middleware for Rails >= 3
require 'exceptiontrap/railtie' if defined?(Rails::Railtie)
# Background Worker Middleware
require "exceptiontrap/sidekiq" if defined?(Sidekiq)

# Exceptiontrap
module Exceptiontrap
  API_VERSION = '1'
  NOTIFIER_NAME = 'exceptiontrap-rails'

  HEADERS = {
    'Content-type' => 'application/json',
    'Accept' => 'application/json'
  }

  # Used by SidekiqException or for manual calls
  def self.notify(exception, params = {})
    return if disabled?
    data = Data.rack_data(exception, params)
    Notifier.notify(data)
  end

  def self.enabled?
    Config.enabled_environments.include?(Data.application_environment)
  end

  def self.disabled?
    !enabled?
  end
end
