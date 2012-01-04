module Exceptiontrap
  class Config
    class << self
      DEFAULTS = {
        :ssl => false,
        :disabled_by_default => %w(development test)
      }

      attr_accessor :api_key, :enabled, :ssl

      def load(config_file=nil)
        if (config_file && File.file?(config_file))
          begin
            config = YAML::load(File.open(config_file))
            env_config = config[application_environment] || {}

            @api_key = config['api-key'] || env_config['api-key']
            @ssl = config['ssl'] || env_config['ssl']
            @ignoreExceptions = config['ignoreExceptions']
            @filterParams = config['filterParams']
            @enabledEnvironments = config['enabledEnvironments']
          rescue Exception => e
            raise ConfigException.new("Unable to load configuration #{config_file} for environment #{application_environment} : #{e.message}")
          end
        end
      end

      def api_key
        return @api_key unless @api_key.nil?
      end

      def enabled_environments
        @enabledEnvironments ||= [""]
      end

      def ignored_exceptions
        @ignoreExceptions ||= [""]
      end

      def filtered_params
        @filterParams || nil
      end

      def application_environment
        ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      end

      def should_send_to_api?
        @enabled ||= DEFAULTS[:disabled_by_default].include?(application_environment) ? false : true
      end

      def application_root
        defined?(Rails.root) ? Rails.root : Dir.pwd
      end

      def ssl?
        @ssl ||= DEFAULTS[:ssl]
      end

      def remote_host
        @remote_host ||= DEFAULTS[:remote_host_http]
      end

      def remote_port
        @remote_port ||= ssl? ? 443 : 80
      end

      def reset
        @enabled = @ssl = @api_key = nil
      end

    end
  end
end