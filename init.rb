# Include hook code here
require 'exceptiontrap'

begin
  # puts "-- Exceptiontrap is active --"
rescue => e
  STDERR.puts "Problem starting Exceptiontrap Plugin. Your app will run as normal."
  STDERR.puts e
end