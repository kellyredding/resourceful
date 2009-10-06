require File.dirname(__FILE__) + '/../test_helper'

class Blog::AuthorTest < Test::Unit::TestCase
  
  should_be_findable '/authors'
  should_have_namespace "Blog"
  
  context "all authors" do
    setup do
      @authors = Blog::Author.find(:all)
    end
    subject { @authors }
    
    should "be a collection of authors" do
      assert_kind_of ::Array, @authors
      assert_kind_of Blog::Author, @authors.first
      assert_equal 1, @authors.first.id
      assert_equal "Joe", @authors.first.name
    end
  end
  
  context "an author" do
    setup do
      @author = Blog::Author.find(:first)
    end
    subject { @author }
    
    should_have_resourceful_attribute :id,   :type => 'integer'
    should_have_resourceful_attribute :name, :type => 'string'
    should_have_resourceful_attribute :publisher_id, :type => 'integer'
    
    should_resourcefully_have_many :posts, :class => "Post"
    should_resourcefully_belong_to :publisher, :class => "Publisher"
    should_resourcefully_contain_one :address, :class => "Address"
    
    should "cache and reload attributes" do
      orig_val = @author.name
      @author.name = "Poo"
      assert_equal "Poo", @author.name
      assert_equal orig_val, @author.name(true)
    end

    should "cache and reload external associations" do
      orig_assoc = @author.posts.dup
      @author.posts << "Another addition"
      assert_equal (orig_assoc + ["Another addition"]), @author.posts
      p "******** should reload external associations"
      reload_assoc = @author.posts(true)
      assert_equal orig_assoc.length, reload_assoc.length
      assert_equal orig_assoc.first.name, reload_assoc.first.name
    end

  end
  
  context "the author with id 1" do
    setup do
      @author = Blog::Author.find(1)
    end
    subject { @author }
    
    should "have an id of 1" do
      assert_equal 1, @author.id
    end
    should "have the name 'Joe'" do
      assert_equal "Joe", @author.name
    end
    should "have multiple posts" do
      assert !@author.posts.empty?
    end
    should "have an address in A City" do
      assert_equal "A City", @author.address.city
    end

  end  
  
end