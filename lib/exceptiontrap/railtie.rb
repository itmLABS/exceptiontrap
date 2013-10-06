require 'exceptiontrap'
require 'exceptiontrap/data'
require 'rails'

module Exceptiontrap
  class ExceptiontrapRailtie < Rails::Railtie
    initializer 'exceptiontrap.middleware' do |app|
      Exceptiontrap::Config.load(File.join(Rails.root, '/config/exceptiontrap.yml'))
      if Exceptiontrap::enabled?
        app.config.middleware.insert_after 'ActionDispatch::ShowExceptions', 'Exceptiontrap::Rack'
      end
    end
  end
end