require 'net/http'
require 'net/https'
require 'uri'

require 'exceptiontrap/version'
require 'exceptiontrap/config'
require 'exceptiontrap/notifier'
require 'exceptiontrap/rack'

# Use Rack Middleware for Rails 3
require 'exceptiontrap/railtie' if defined?(Rails::Railtie)

# Exceptiontrap
module Exceptiontrap
  API_VERSION = '1'
  NOTIFIER_NAME = 'exceptiontrap-rails'
  NOTIFICATION_URL = 'alpha.exceptiontrap.com/notifier/api/v1/problems'
  DEPLOYMENT_URL = 'alpha.exceptiontrap.com/notifier/api/v1/deployments'

  HEADERS = {
    'Content-type' => 'application/json',
    'Accept' => 'application/json'
  }

  # Load for Rails 2.3 (Rack and Exceptiontrap::Catcher)
  if !defined?(Rails::Railtie) && defined?(Rails.configuration) && Rails.configuration.respond_to?(:middleware)
    Exceptiontrap::Config.load(File.join(Rails.root, '/config/exceptiontrap.yml'))

    if Config.enabled_environments.include?(Exceptiontrap::Data.application_environment)
      if defined?(ActionController::Base) && !ActionController::Base.include?(Exceptiontrap::Catcher)
        ActionController::Base.send(:include, Exceptiontrap::Catcher) # puts "-> Activated Exceptiontrap::Catcher for Rails 2"
      end

      Rails.configuration.middleware.use 'Exceptiontrap::Rack' # puts "-> Activated Exceptiontrap::Rack for Rails 2.3+"
    end
  end

end