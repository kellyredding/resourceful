When /^I load the "([^\"]*)" widget model "([^\"]*)"$/ do |klass, id|
  @result = "RestClientWidget#{klass}".resourceful_constantize.find(id)
end

When /^I create a new "([^\"]*)" widget model$/ do |klass|
  @result = "RestClientWidget#{klass}".resourceful_constantize.new
end

When /^I load the "([^\"]*)" widgets collection$/ do |klass|
  @result = "RestClientWidget#{klass}".resourceful_constantize.find(:all)
end

When /^I update "([^\"]*)" to be "([^\"]*)"$/ do |a, v|
  @result.send(a, v)
end

When /^I save the widget$/ do
  @result.save
end

When /^destroy the widget$/ do
  @result.destroy
end


Then /^the result should be a valid Widget model$/ do
  assert_valid_widget_model @result
end

Then /^the result should be a collection of valid Widget models$/ do
  assert_kind_of Array, @result
  assert_valid_widget_model @result.first
end

def assert_valid_widget_model(widget)
  [:id, :name, :attributes].each do |attribute|
    assert widget.respond_to?(attribute)
    assert_not_nil widget.send(attribute.to_s)
  end
end