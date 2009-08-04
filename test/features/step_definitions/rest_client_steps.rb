Given /^I have no RestClient host server configured$/ do
  @agent = Resourceful::Agent::RestClient.new
end

Given /^I have a configured RestClient resource host$/ do
  @agent = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host])
end

Given /^I have a configured RestClient resource host set to log$/ do
  log_file = File.expand_path(RESOURCE_CONFIG[:log])
  FileUtils.rm(log_file) if File.exists?(log_file)
  @agent = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host]) {
    RESOURCE_CONFIG[:log]
  }
end

Then /^RestClient should complain about the resource not being found$/ do
  assert @result
  assert_kind_of RestClient::ResourceNotFound, @result
  assert @result.message.length > 0
end
