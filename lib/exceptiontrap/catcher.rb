module Exceptiontrap
  module Catcher
    def self.included(base)
      # Uses the public rescue method
      base.send(:alias_method, :original_rescue_action_in_public, :rescue_action_in_public)
      base.send(:alias_method, :rescue_action_in_public, :rescue_action_public_exceptiontrap)

      # Uses the local rescue method
      base.send(:alias_method, :original_rescue_action_locally, :rescue_action)
      base.send(:alias_method, :rescue_action, :rescue_action_local_exceptiontrap)
    end

    private
    # When the exception occured in public
    def rescue_action_public_exceptiontrap(exception)
      handle_with_exceptiontrap(exception)
      original_rescue_action_in_public(exception) # to rails again
    end

    # When the exception occured locally
    def rescue_action_local_exceptiontrap(exception)
      handle_with_exceptiontrap(exception)
      original_rescue_action_locally(exception) # to rails again
    end

    # Sends the exception to exceptiontrap
    def handle_with_exceptiontrap(exception)
      # puts "DEBUG: Raised Exceptiontrap::Catcher::Exception"
      data = Exceptiontrap::Data.rails2_data(exception, request, session, response)
      Exceptiontrap::Notifier.notify(data)
    end

  end

end