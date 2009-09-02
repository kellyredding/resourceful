Dir[File.join(File.dirname(__FILE__), "resource" ,"*.rb")].each do |file|
  require "resourceful/resource/#{File.basename(file, ".rb")}"
end
