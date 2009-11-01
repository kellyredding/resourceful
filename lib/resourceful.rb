%w(nokogiri json log4r useful/ruby_extensions).each do |lib|
  require lib
end

%w(exceptions extensions resource agent model).each do |file|
  require "resourceful/#{file}"
end
