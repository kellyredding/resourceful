Dir[File.join(File.dirname(__FILE__), "model" ,"*.rb")].each do |file|
  require file
end
