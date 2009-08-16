Given /^I have no Mechanize host server configured$/ do
  @agent = Resourceful::Agent::Mechanize.new
end

Given /^I have a configured Mechanize resource host$/ do
  @agent = Resourceful::Agent::Mechanize.new(:host => RESOURCE_CONFIG[:host])
end

Given /^I have a configured Mechanize resource host set to log$/ do
  log_file = File.expand_path(RESOURCE_CONFIG[:log])
  FileUtils.rm(log_file) if File.exists?(log_file)
  @agent = Resourceful::Agent::Mechanize.new(:host => RESOURCE_CONFIG[:host], :verbose => true) {
    RESOURCE_CONFIG[:log]
  }
end

Then /^Mechanize should complain about the resource not being found$/ do
  assert @result
  assert_kind_of WWW::Mechanize::ResponseCodeError, @result
  assert @result.message.length > 0
  assert_match "404", @result.message
end
