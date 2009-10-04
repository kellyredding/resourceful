class Blog::Author < Resourceful::Model::Json
  
  add_namespace "Blog"
  agent do
    Resourceful::Agent::RestClient.new(:host => BLOG_HOST, :log_prefix => "Blog::Post")
  end
  
  include Resourceful::Model::Findable
  def self.findable_index
    "/authors"
  end
  def findable_index
    self.class.findable_index
  end
  
  attribute :id, :integer
  attribute :name, :string
  
  include Resourceful::Model::ExternalAssociations  
  has_many :posts, :class => "Post"
  
  include Resourceful::Model::EmbeddedAssociations
  contains_one :address, :class => "Address"
  
  protected
  
  def self.findable_default_opts
    {}
  end
  
end
