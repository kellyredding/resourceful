Given /^I want to use the (.+) resource format$/ do |format|
  @format = Resourceful::Resource::Format.get(format)
end

Given /^I have no host server configured$/ do
  Resourceful::Resource::Base.configure
end

Given /^I have a configured resource host$/ do
  Resourceful::Resource::Base.configure(:host => RESOURCE_CONFIG[:host])
end

Given /^I have a configured resource host set to log$/ do
  log_file = File.expand_path(RESOURCE_CONFIG[:log])
  FileUtils.rm(log_file) if File.exists?(log_file)
  Resourceful::Resource::Base.configure(:host => RESOURCE_CONFIG[:host]) {
    RESOURCE_CONFIG[:log]
  }
end

