Then /^the format should be \.(.+)$/ do |format|
  assert_equal @format.to_s, format
end

Then /^the host should be set$/ do
  assert_equal Resourceful::Resource.host, RESOURCE_CONFIG[:host]
end

Then /^resourceful should complain about a configuration error$/ do
  assert_raise Resourceful::Exceptions::ConfigurationError do
    Resourceful::Resource::Base.get RESOURCE_CONFIG[:resource], :format => 'json', :params => RESOURCE_CONFIG[:params]
  end
end

Then /^verify the log settings$/ do
  assert_equal Resourceful::Resource.logger.outputters.detect{|out| out.respond_to?('filename')}.filename, RESOURCE_CONFIG[:log]
end

Then /^the set log file should exist$/ do
  log_file = File.expand_path(RESOURCE_CONFIG[:log])  
  assert File.exists?(log_file)
  FileUtils.rm(log_file) if File.exists?(log_file)
end
