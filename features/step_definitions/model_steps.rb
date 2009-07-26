Given /^I am user with the screen_name "([^\"]*)"$/ do |screen_name|
  @screen_name = screen_name
end

When /^I load my "([^\"]*)" user model$/ do |klass|
  @result = "User#{klass}".constantize.find(@screen_name)
end

When /^I load the "([^\"]*)" status "([^\"]*)"$/ do |klass, collection|
  @result = "Status#{klass}".constantize.find(collection)
end

Then /^the result should be a valid User model$/ do
  [:id, :name, :screen_name, :location, :description, :profile_image_url, :url, :protected, :followers_count, :friends_count, :created_on, :last_status_at, :last_status].each do |attribute|
    assert @result.respond_to?(attribute)
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
end

Then /^the result should be a collection of valid Status models$/ do
  assert_kind_of Array, @result
  assert_equal 20, @result.length

  [:id, :text, :source, :truncated, :favorited, :reply_status, :reply_user, :user_id, :user_screen_name, :user].each do |attribute|
    assert @result.first.respond_to?(attribute)
    assert_nothing_raised do
      @result.first.send(attribute.to_s)
    end
  end
  
  [:id, :text, :truncated, :favorited, :user_id, :user_screen_name, :user].each do |attribute|
    assert !@result.first.send(attribute.to_s).nil?
  end
  
  assert_kind_of Resourceful::Model::Base, @result.first.user  
  
end
