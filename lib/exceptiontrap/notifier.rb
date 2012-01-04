module Exceptiontrap
  class Notifier
    class << self
      def notify(data)
        puts "DEBUG: Notify Exception"

        @data = data
        xml_data = data.to_xml({:root => 'problem', :skip_types => true}).to_s
        send_problem(xml_data) if !ignore_exception?
      end

      def send_problem(xml_data)
        puts "DEBUG: Send Exception"

        url = URI.parse(NOTIFICATION_URL)
        http = Net::HTTP.new(url.host, url.port)

        response = begin
          http.post(url.path, xml_data, HEADERS)
        rescue TimeoutError => e
          puts "ERROR: Timeout while contacting Exceptiontrap."
          nil
        rescue Exception => e
          puts "ERROR: Error on sending: #{e.class} - #{e.message}"
        end
      end

      def ignore_exception?
        Config.ignored_exceptions.include?(@data['name'])
      end

    end
  end
end
