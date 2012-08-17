module Exceptiontrap
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        puts 'DEBUG: Begin Exceptiontrap::Rack'
        response = @app.call(env)
      rescue Exception => raised
        puts 'DEBUG: Raised Exceptiontrap::Rack::Exception'
        data = Exceptiontrap::Data.rack_data(raised, env)
        Exceptiontrap::Notifier.notify(data)
        raise
      end

      response
    end

  end
end