module Exceptiontrap
  class Data
    class << self
      # TODO: Remove the duplication
      # Creates Notification Data for action controller requests (Rails 2)
      def rails2_data(exception, request, session, response)
        data = {
          'notifier' => NOTIFIER_NAME,
          'api-key' => Config.api_key,
          'name' => exception.class.name,
          'message' => exception.message,
          'root' => application_root,
          'app-environment' => application_environment,
          'request-uri' => request.url || REQUEST_URI,
          'request-params' => clean_params(request.params),
          'request-session' => clean_params(extrap_session_data(session)),
          'environment' => clean_params(request.env),
          'trace' => clean_backtrace(exception).join("\n"),
          'request-components' => { :controller => request.params[:controller], :action => request.params[:action] }
        }
      end

      # Creates Notification Data for rack requests (Rails 3)
      def rack_data(exception, env)
        components = { }
        if env["action_dispatch.request.parameters"] != nil
          components[:controller] = env["action_dispatch.request.parameters"][:controller] || nil
          components[:action] = env["action_dispatch.request.parameters"][:action] || nil
          components[:module] = env["action_dispatch.request.parameters"][:module] || nil
        end

        data = {
          'notifier' => NOTIFIER_NAME,
          'api-key' => Config.api_key,
          'name' => exception.class.name,
          'message' => exception.message,
          'root' => application_root,
          'app-environment' => application_environment,
          'request-uri' => env["REQUEST_URI"],
          'request-params' => clean_params(env["action_dispatch.request.parameters"]),
          'request-session' => clean_params(extrap_session_data(env["rack.session"])),
          'environment' => clean_params(env),
          'trace' => clean_backtrace(exception).join("\n"),
          'request-components' => components
        }
      end

      ### Cleanup
      def clean_params(params)
        return if params == nil

        params = normalize_data(params)
        params = filter_params(params)
        params
      end

      # Deletes params from env / set in config file
      def remove_params
        remove_params = ["rack.request.form_hash", "rack.request.form_vars", "rack.request.form_hash"]
      end

      # Trims first underscore from keys, to prevent "malformed" rails XML-tags
      def normalize_data(hash)
        new_hash = {}

        # TODO: Do this nicer
        hash.each do |key, value|
          key_s = key.to_s.dup
          key_s.sub!("_", "") if key_s[0].chr == "_"
          key_s.sub!("_", "") if key_s[0].chr == "_"

          if value.respond_to?(:to_hash) # if hash, normalize these too
            new_hash[key_s] = normalize_data(value.to_hash)
          else
            new_hash[key_s] = value.to_s
          end
        end

        new_hash
      end

      # Replaces parameter values with a string / set in config file
      def filter_params(params)
        if Config.filtered_params
          params.each do |key, value|
            if filter_key?(key)
              params[key] = "[FILTERED]"
            elsif value.respond_to?(:to_hash)
              filter_params(params[key])
            end
          end
        end
        params
      end

      # Check, if a key should be filtered
      def filter_key?(key)
        Config.filtered_params.any? do |filter|
          key.to_s.include?(filter.to_s)
        end
      end

      ### Getter
      def extrap_session_data(session)
        return if session == nil
        if session.respond_to?(:to_hash)
          session.to_hash
        else
          session.data
        end
      end

      def application_environment
        ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      end

      def application_root
        defined?(Rails.root) ? Rails.root : Dir.pwd
      end

      def clean_backtrace(exception)
        if Rails.respond_to?(:backtrace_cleaner)
          Rails.backtrace_cleaner.send(:filter, exception.backtrace)
        else
          exception.backtrace
        end
      end

    end
  end
end