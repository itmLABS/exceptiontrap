module Exceptiontrap
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => exception
        puts "[Exceptiontrap] Caught Exception: #{exception.class.name}"

        data = Exceptiontrap::Data.rack_data(exception, env)
        Exceptiontrap::Notifier.notify(data)

        raise
      end

      response
    end

  end
end
