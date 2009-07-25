Dir[File.join(File.dirname(__FILE__), "resource" ,"*.rb")].each do |file|
  require file
end
