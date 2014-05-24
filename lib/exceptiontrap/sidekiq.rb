module Exceptiontrap
  class SidekiqException
    def call(worker, msg, queue)
      begin
        yield
      rescue => exception
        Exceptiontrap::notify(exception, { custom_params: msg, custom_controller: msg['class'] })
        raise exception
      end
    end
  end
end

if Sidekiq::VERSION < '3'
  # old behavior
  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add Exceptiontrap::SidekiqException
    end
  end
else
  Sidekiq.configure_server do |config|
    config.error_handlers << Proc.new {|ex, context| Exceptiontrap::notify(ex, context.merge(custom_controller: context['class'])) }
  end
end