module Exceptiontrap
  class Data
    class << self
      # TODO: Remove the duplication or separate classes
      # Creates Notification Data for action controller requests (Rails 2)
      def rails2_data(exception, request, session, response)
        data = {
          'notifier' => NOTIFIER_NAME,
          'name' => exception.class.name,
          'message' => exception.message,
          'location' => location(exception),
          'root' => application_root.to_s,
          'app_environment' => application_environment,
          'request_uri' => request.url || REQUEST_URI,
          'request_params' => clean_params(request.params),
          'request_session' => clean_params(extrap_session_data(session)),
          'environment' => clean_params(request.env),
          'trace' => clean_backtrace(exception.backtrace),
          'request_components' => { :controller => request.params[:controller], :action => request.params[:action] }
        }
      end

      # Creates Notification Data for rack requests (Rails 3)
      def rack_data(exception, env)
        components = {}
        if env["action_dispatch.request.parameters"] != nil
          components[:controller] = env['action_dispatch.request.parameters'][:controller] || nil
          components[:action] = env['action_dispatch.request.parameters'][:action] || nil
          components[:module] = env['action_dispatch.request.parameters'][:module] || nil
        end

        data = {
          'notifier' => NOTIFIER_NAME,
          'name' => exception.class.name,
          'message' => exception.message,
          'location' => location(exception),
          'root' => application_root.to_s,
          'app_environment' => application_environment,
          'request_uri' => rack_request_url(env),
          'request_params' => clean_params(env['action_dispatch.request.parameters']),
          'request_session' => clean_params(extrap_session_data(env['rack.session'])),
          'environment' => clean_params(env),
          'trace' => clean_backtrace(exception.backtrace),
          'request_components' => components
        }
      end

      def rack_request_url(env)
        protocol = rack_scheme(env)
        protocol = protocol.nil? ? "" : "#{protocol}://"

        host = env['SERVER_NAME'] || ""
        path = env['REQUEST_URI'] || ""
        port = env['SERVER_PORT'] || "80"
        port = ["80", "443"].include?(port.to_s) ? "" : ":#{port}"

        protocol.to_s + host.to_s + port.to_s + path.to_s;
      end

      def rack_scheme(env)
        if env['HTTPS'] == 'on'
          'https'
        elsif env['HTTP_X_FORWARDED_PROTO']
          env['HTTP_X_FORWARDED_PROTO'].split(',')[0]
        else
          env["rack.url_scheme"]
        end
      end

      # Cleanup data
      def clean_params(params)
        return if params == nil
        params = normalize_data(params)
        params = filter_params(params)
      end

      def clean_backtrace(backtrace)
        if Rails.respond_to?(:backtrace_cleaner)
          Rails.backtrace_cleaner.send(:filter, backtrace)
        else
          backtrace
        end
      end

      # Deletes params from env / set in config file
      def remove_params
        remove_params = ['rack.request.form_hash', 'rack.request.form_vars']
      end

      # Replaces parameter values with a string / set in config file
      def filter_params(params)
        return params unless Config.filtered_params

        params.each do |k, v|
          if filter_key?(k)
            params[k] = '[FILTERED]'
          elsif v.respond_to?(:to_hash)
            filter_params(params[k])
          end
        end

        params
      end

      # Check, if a key should be filtered
      def filter_key?(key)
        Config.filtered_params.any? do |filter|
          key.to_s == filter.to_s # key.to_s.include?(filter.to_s)
        end
      end

      # Retrieve data
      def extrap_session_data(session)
        return if session == nil
        if session.respond_to?(:to_hash)
          session.to_hash
        else
          session.data
        end
      end

      def location(exception)
        #TODO: Implement
      end

      def application_environment
        ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      end

      def application_root
        defined?(Rails.root) ? Rails.root : Dir.pwd
      end

      # Trims first underscore from keys, to prevent "malformed" rails XML-tags
      def normalize_data(hash)
        new_hash = {}

        # TODO: Do this nicer
        hash.each do |key, value|
          # key_s = key.to_s.dup
          # key_s.sub!("_", "") if key_s[0].chr == "_"
          # key_s.sub!("_", "") if key_s[0].chr == "_"

          if value.respond_to?(:to_hash) # if hash, normalize these too
            new_hash[key] = normalize_data(value.to_hash)
          else
            new_hash[key] = value.to_s
          end
        end

        new_hash
      end

    end
  end
end