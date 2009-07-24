Given /^I am user with the screen_name "([^\"]*)"$/ do |screen_name|
  @screen_name = screen_name
end

When /^I load my "([^\"]*)" user model$/ do |klass|
  name = "User#{klass}"
  constant = ::Object
  model_klass = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
  @result = model_klass.find(@screen_name)
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
    assert_equal @result.send(k.to_s), v
  end
  assert_kind_of DateTime, @result.last_status_at
  assert !@result.last_status.nil?
  assert @result.last_status != ''
end
