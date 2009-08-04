Given /^I am user with the screen_name "([^\"]*)"$/ do |screen_name|
  @screen_name = screen_name
end

When /^I load my "([^\"]*)" user model$/ do |klass|
  @result = "RestClientUser#{klass}".constantize.find(@screen_name)
end

When /^I load the "([^\"]*)" status "([^\"]*)"$/ do |klass, collection|
  @result = "RestClientStatus#{klass}".constantize.find(collection)
end

Then /^the result should be a valid User model$/ do
  [:id, :name, :screen_name, :location, :description, :profile_image_url, :url, :protected, :followers_count, :friends_count, :created_on, :last_status_at, :last_status].each do |attribute|
    assert @result.respond_to?(attribute)
    assert_not_nil @result
  end
  {
    :id => 38225297,
    :name => "Kelly Redding",
    :screen_name => "kelredd",
    :protected => false,
    :created_on => Date.strptime("2009-05-06")
  }.each do |k,v|
    assert_equal v, @result.send(k.to_s)
  end
  assert_kind_of DateTime, @result.last_status_at
  assert !@result.last_status.nil?
  assert @result.last_status != ''
  
  assert_kind_of Resourceful::Model::Base, @result.last_status
  assert_valid_status(@result.last_status)
end

Then /^the result should be a collection of valid Status models$/ do
  assert_kind_of Array, @result
  assert_equal 20, @result.length
  assert_valid_status(@result.first)

  [:user_id, :user_screen_name, :user].each do |attribute|
    assert @result.first.respond_to?(attribute)
    assert_nothing_raised do
      @result.first.send(attribute.to_s)
    end
  end
  [:user_id, :user_screen_name, :user].each do |attribute|
    assert !@result.first.send(attribute.to_s).nil?
  end
  assert_kind_of Resourceful::Model::Base, @result.first.user  
end

Then /^the result should be a valid Json model$/ do
  assert_valid_json_model(@result)
end

Then /^the result should be a collection of valid Json models$/ do
  assert_valid_json_model(@result.first)
end

def assert_valid_status(status)
  [:id, :text, :source, :truncated, :favorited, :reply_status, :reply_user].each do |attribute|
    assert status.respond_to?(attribute)
    assert_nothing_raised do
      status.send(attribute.to_s)
    end
  end
  
  [:id, :text, :truncated, :favorited].each do |attribute|
    assert !status.send(attribute.to_s).nil?
  end
end

def assert_valid_json_model(json)
  assert json.respond_to?(:attributes)
  assert_not_nil json.attributes  
end