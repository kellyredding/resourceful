When /^I get a[n]* (.+) formatted resource$/ do |format|
  @result = ResourcefulFeature::Helpers.safe_run_get do
    Resourceful::Resource::Base.get RESOURCE_CONFIG[:resource], :format => format, :params => RESOURCE_CONFIG[:params]
  end
end

When /^I get a[n]* (.+) formatted implicitly resource$/ do |format|
  @result = ResourcefulFeature::Helpers.safe_run_get do
    Resourceful::Resource::Base.get RESOURCE_CONFIG[:resource]+".#{format}", :params => RESOURCE_CONFIG[:params]
  end
end

When /^I get a resource that does not exist$/ do
  @result = ResourcefulFeature::Helpers.safe_run_get do
    Resourceful::Resource::Base.get '/unknown', :format => 'xml', :params => RESOURCE_CONFIG[:params]
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

Then /^resourceful should complain about the resource not being found$/ do
  assert @result
  assert_kind_of RestClient::ResourceNotFound, @result
  assert @result.message.length > 0
end
