Dir[File.join(File.dirname(__FILE__), "agent" ,"*.rb")].each do |file|
  require "resourceful/agent/#{File.basename(file, ".rb")}"
end
