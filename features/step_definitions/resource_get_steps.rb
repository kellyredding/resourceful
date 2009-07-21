When /^I get a[n]* (.+) resource$/ do |format|
  begin
    @result = Resourceful::Resource::Base.get RESOURCE_CONFIG[:resource], :format => format, :params => RESOURCE_CONFIG[:params]
  rescue Exception => err
    @complaint = err
  end
end

When /^I get a resource that does not exist$/ do
  begin
    @result = Resourceful::Resource::Base.get '/unknown', :format => 'xml', :params => RESOURCE_CONFIG[:params]
  rescue Exception => err
    @complaint = err
  end
end

Then /^the result should be a hash object$/ do
  assert_kind_of Hash, @result.first
end

Then /^the result should be an xml object$/ do
  assert_kind_of Nokogiri::XML::Document, @result
end

Then /^resourceful should complain about a format error$/ do
  assert @complaint
  assert_kind_of Resourceful::Exceptions::FormatError, @complaint
  assert @complaint.message.length > 0
end

Then /^resourceful should complain about the resource not being found$/ do
  assert @complaint
  assert_kind_of RestClient::ResourceNotFound, @complaint
  assert @complaint.message.length > 0
end
