class ExceptiontrapGenerator < Rails::Generator::Base
  def add_options!(opt)
    opt.on('-k', '--api-key=key', String, "Your Exceptiontrap API key") {|v| options[:api_key] = v}
  end

  def manifest
    if !options[:api_key]
      puts "You have to pass --api-key or create config/exceptiontrap.yml manually"
      exit
    end

    record do |m|
      m.template 'exceptiontrap.yml', 'config/exceptiontrap.yml', :assigns => {:api_key => api_key}
    end
  end

  def api_key
  	return "#{options[:api_key]}"
  end

end
