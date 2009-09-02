Dir[File.join(File.dirname(__FILE__), "model" ,"*.rb")].each do |file|
  require "resourceful/model/#{File.basename(file, ".rb")}"
end
