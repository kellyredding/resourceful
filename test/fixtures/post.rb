class Blog::Post < Resourceful::Model::Xml
  
  add_namespace "Blog"
  agent do
    Resourceful::Agent::RestClient.new(:host => BLOG_HOST, :log_prefix => "Blog::Post")
  end
  
  include Resourceful::Model::Findable
  def self.findable_index
    "/posts"
  end
  def findable_index
    self.class.findable_index
  end
  
  attribute :id, :integer
  attribute :name, :string
  attribute :author_id, :integer, :path => 'author-id'
  
  include Resourceful::Model::ExternalAssociations
  belongs_to :author, :class => Blog::Author
  
  include Resourceful::Model::EmbeddedAssociations
  contains_many :comments, :class => "Comment", :path => "comments/comment"
  
  protected
  
  def self.findable_default_opts
    {}
  end
  
end
