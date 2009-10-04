require File.dirname(__FILE__) + '/../test_helper'

class Blog::PostTest < Test::Unit::TestCase
  
  should_be_findable '/posts'
  should_have_namespace "Blog"
  
  context "all posts" do
    setup do
      @posts = Blog::Post.find(:all)
    end
    subject { @posts }
    
    should "be a collection of posts" do
      assert_kind_of ::Array, @posts
      assert_kind_of Blog::Post, @posts.first
      assert_equal 1, @posts.first.id
      assert_equal "One", @posts.first.name
      assert_equal 1, @posts.first.author_id
    end
  end
  
  context "a post" do
    setup do
      @post = Blog::Post.find(:first)
    end
    subject { @post }
    
    should_have_resourceful_attribute :id,   :type => 'integer'
    should_have_resourceful_attribute :name, :type => 'string'
    
    should_resourcefully_belong_to :author, :class => "Author"
    should_resourcefully_contain_many :comments, :class => "Comment"

  end
  
  context "the post with id 1" do
    setup do
      @post = Blog::Post.find(1)
    end
    subject { @post }
    
    should "have an id of 1" do
      assert_equal 1, @post.id
    end
    should "have the name 'Joe'" do
      assert_equal "One", @post.name
    end
    should "have the author 'Joe'" do
      assert_equal 1, @post.author_id
      assert_equal "Joe", @post.author.name
    end
    should "have a few comments" do
      assert !@post.comments.empty?
      assert_equal "Blah Blah", @post.comments.first.text
    end

  end  
  
end