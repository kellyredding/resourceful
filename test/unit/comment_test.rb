require "#{File.dirname(__FILE__)}/../test_helper"

class Blog::CommentTest < Test::Unit::TestCase
  
  context "a comment" do
    
    setup do
      @comment = Blog::Post.find(:first).comments.first
    end
    subject { @comment }

    # Test out all supported attribute types and attribute parsing options
    should_have_resourceful_attribute :user_name, :type => 'string', :path => 'user-name'
    should_have_resourceful_attribute :text, :type => 'text'
    should_have_resourceful_attribute :count, :type => 'integer'
    should_have_resourceful_attribute :average, :type => 'float'
    should_have_resourceful_attribute :cost, :type => 'currency'
    should_have_resourceful_attribute :on, :type => 'date'
    should_have_resourceful_attribute :at, :type => 'datetime'
    should_have_resourceful_attribute :valid, :type => 'boolean'
    
    # Test advanced parsing options
    should_have_resourceful_attribute :text_type, :type => 'string', :path => "text/@type"
    should_have_resourceful_attribute :text_key, :type => 'integer', :path => "text/@key", :value => /integer-([0-9]+)/
    should_have_resourceful_attribute :line_one, :type => 'string', :path => "line[@class='one']"
    should_have_resourceful_attribute :two_line, :type => 'boolean', :path => "line[@class='two']"
    should_have_instance_methods 'two_line?'
    should_have_resourceful_attribute :three_line, :type => 'boolean', :path => "line[@class='three']"
    should_have_instance_methods 'three_line?'
    
    # Test for correct values actually being parsed
    should "have user_name of 'foo'" do
      p "comment user name: #{@comment.user_name.inspect}"
      assert_equal "foo", @comment.user_name
    end
    should "have text of 'Blah Blah'" do
      p "comment text: #{@comment.text.inspect}"
      assert_equal "Blah Blah", @comment.text
    end
    should "have count of 362" do
      p "comment count: #{@comment.count.inspect}"
      assert_equal 362, @comment.count
    end
    should "have average of 141.72345" do
      p "comment average: #{@comment.average.inspect}"
      assert_equal 141.72345, @comment.average
    end
    should "have cost of $9.99" do
      p "comment cost: #{@comment.cost.inspect}"
      assert_equal 9.99, @comment.cost
    end
    should "be on 10/25/2009" do
      p "comment on: #{@comment.on.inspect}"
      assert_equal "10/25/2009".to_date, @comment.on
    end
    should "be at 10/25/2009 13:45:27" do
      p "comment at: #{@comment.at.inspect}"
      assert_equal "10/25/2009 13:45:27".to_datetime, @comment.at.to_datetime
    end
    should "be valid" do
      p "comment valid: #{@comment.valid.inspect}"
      assert @comment.valid == true
    end

    should "have text type of 'boring'" do
      p "comment text type: #{@comment.text_type.inspect}"
      assert_equal "boring", @comment.text_type
    end
    should "have text key of '123'" do
      p "comment text key: #{@comment.text_key.inspect}"
      assert_equal 123, @comment.text_key
    end
    should "have line one of 'line 1" do
      p "comment line one: #{@comment.line_one.inspect}"
      assert_equal "line 1", @comment.line_one
    end
    should "not be two line" do
      p "is comment two line?: #{@comment.two_line.inspect}"
      assert [false, nil].include?(@comment.two_line)
    end
    should "be three line" do
      p "is comment three line?: #{@comment.three_line.inspect}"
      assert_equal true, @comment.three_line
    end

  end
  
end