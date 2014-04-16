module Exceptiontrap
  class Config
    class << self
      DEFAULTS = {
        :enabled_environments => %w(production),
        :ignored_exceptions => %w(ActiveRecord::RecordNotFound ActionController::RoutingError),
        :filtered_params => %w(password s3-key),
        :ssl => false
      }

      def load(config_file = nil)
        if (config_file && File.file?(config_file))
          begin
            config = YAML::load(File.open(config_file))

            @api_key = ENV['EXCEPTIONTRAP_API_KEY'] || config['api-key']
            @ssl = config['ssl']
            @ignored_exceptions = config['ignoreExceptions']
            @enabled_environments = config['enabledEnvironments']
            @filtered_params = config['filterParams']
          rescue Exception => e
            raise Exception.new("Unable to load configuration #{config_file} : #{e.message}")
          end
        end
      end

      def api_key
        @api_key
      end

      def enabled_environments
        @enabled_environments ||= DEFAULTS[:enabled_environments]
      end

      def ignored_exceptions
        @ignored_exceptions ||= DEFAULTS[:ignored_exceptions]
      end

      def filtered_params
        @filtered_params ||= DEFAULTS[:filtered_params]
      end

      def use_ssl?
        @ssl ||= DEFAULTS[:ssl]
      end

    end
  end
end