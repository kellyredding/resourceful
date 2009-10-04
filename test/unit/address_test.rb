require File.dirname(__FILE__) + '/../test_helper'

class Blog::AddressTest < Test::Unit::TestCase
  
  context "an address" do
    setup do
      @address = Blog::Author.find(:first).address
    end
    subject { @address }

    should_have_resourceful_attribute :street, :type => 'string'
    should_have_resourceful_attribute :city, :type => 'string'
    should_have_resourceful_attribute :state, :type => 'string'

  end
  
end