require 'exceptiontrap'
require 'exceptiontrap/data'
require 'rails'

module Exceptiontrap
  class ExceptiontrapRailtie < Rails::Railtie
    initializer 'exceptiontrap.middleware' do |app|
      Exceptiontrap::Config.load(File.join(Rails.root, '/config/exceptiontrap.yml'))
      if Config.enabled_environments.include?(Exceptiontrap::Data.application_environment)
        # puts "-> Activated Exceptiontrap::Rack for Rails 3 (Railtie)"
        app.config.middleware.insert_after 'ActionDispatch::ShowExceptions', 'Exceptiontrap::Rack'
      end
    end
  end
end