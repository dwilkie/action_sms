# Load each available adapter
Dir["#{File.dirname(__FILE__)}/connection_adapters/*.rb"].sort.each do |path|
  require "action_sms/connection_adapters/#{File.basename(path)}"
end

