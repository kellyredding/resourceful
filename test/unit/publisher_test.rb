require File.dirname(__FILE__) + '/../test_helper'

class Blog::PublisherTest < Test::Unit::TestCase
  
  should_be_findable '/publishers'
  should_have_namespace "Blog"
  
  context "all publishers" do
    setup do
      @publishers = Blog::Publisher.find(:all)
    end
    subject { @publishers }
    
    should "be a collection of publishers" do
      assert_kind_of ::Array, @publishers
      assert_kind_of Blog::Publisher, @publishers.first
      assert_equal 1, @publishers.first.id
      assert_equal "Jasper", @publishers.first.name
    end
  end
  
  context "a publisher" do
    setup do
      @publisher = Blog::Publisher.find(:first)
    end
    subject { @publisher }
    
    should_have_resourceful_attribute :id,   :type => 'integer'
    should_have_resourceful_attribute :name, :type => 'string'
    
    should_resourcefully_have_many :authors, :class => "Author"
    
  end
  
end