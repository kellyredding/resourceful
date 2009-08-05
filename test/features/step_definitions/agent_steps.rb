Given /^I want to use the (.+) resource format$/ do |format|
  @format = Resourceful::Resource::Format.get(format)
end

Then /^the format should be \.(.+)$/ do |format|
  assert_equal @format.to_s, format
end

Then /^the host should be set$/ do
  assert_equal @agent.host, RESOURCE_CONFIG[:host]
end

Then /^resourceful should complain about a configuration error$/ do
  assert_raise Resourceful::Exceptions::ConfigurationError do
    @agent.get RESOURCE_CONFIG[:resource]+'.json', :format => 'json', :params => RESOURCE_CONFIG[:params]
  end
end

Then /^verify the log settings$/ do
  assert_equal @agent.logger.outputters.detect{|out| out.respond_to?('filename')}.filename, RESOURCE_CONFIG[:log]
end

Then /^the set log file should exist$/ do
  log_file = File.expand_path(RESOURCE_CONFIG[:log])  
  assert File.exists?(log_file)
  FileUtils.rm(log_file) if File.exists?(log_file)
end




When /^I get a[n]* (.+) formatted resource$/ do |format|
  @result = ResourcefulFeature::Helpers.safe_run_get do
    @agent.get RESOURCE_CONFIG[:resource]+".#{format}", :format => format, :params => RESOURCE_CONFIG[:params]
  end
end

When /^I get a[n]* (.+) formatted implicitly resource$/ do |format|
  @result = ResourcefulFeature::Helpers.safe_run_get do
    @agent.get RESOURCE_CONFIG[:resource]+".#{format}", :params => RESOURCE_CONFIG[:params]
  end
end

When /^I get a resource that does not exist$/ do
  @result = ResourcefulFeature::Helpers.safe_run_get do
    @agent.get '/unknown.xml', :format => 'xml', :params => RESOURCE_CONFIG[:params]
  end
end

Then /^the result should be a hash object$/ do
  assert_kind_of Hash, @result.first
end

Then /^the result should be an xml object$/ do
  assert_kind_of Nokogiri::XML::Document, @result
end

Then /^resourceful should complain about a format error$/ do
  assert @result
  assert_kind_of Resourceful::Exceptions::FormatError, @result
  assert @result.message.length > 0
end
