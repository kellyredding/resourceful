%w(rubygems nokogiri json log4r).each do |lib|
  require lib
end

%w(exceptions extensions resource agent model).each do |file|
  require File.join(File.dirname(__FILE__), 'resourceful', "#{file}.rb")
end
