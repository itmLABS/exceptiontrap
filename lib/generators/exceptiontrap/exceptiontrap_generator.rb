require 'rails/generators'

class ExceptiontrapGenerator < Rails::Generators::Base
  desc "Run this generator to create the Exceptiontrap config file"
  
  class_option :api_key, :aliases => "-k", :type => :string, :desc => "Your Exceptiontrap API key"
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def install
    if !options[:api_key]
      puts "You have to pass --api-key or create config/exceptiontrap.yml manually"
      exit
    end
    #copy_config
  end
  
  def api_key
  	s = "#{options[:api_key]}"
  end
  
  def copy_config
    puts "Copying config file to your app"
    template 'exceptiontrap.yml', 'config/exceptiontrap.yml'
  end
end
