class Blog::Author < Resourceful::Model::Json
  
  add_namespace "Blog"
  agent do
    Resourceful::Agent::RestClient.new(:host => BLOG_HOST, :log_prefix => "Blog::Author")
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
  attribute :parent_type, :string
  attribute :parent_id, :integer
  
  include Resourceful::Model::ExternalAssociations  
  belongs_to :parent, :polymorphic => true
  has_many :posts, :class => "Post"
  
  include Resourceful::Model::EmbeddedAssociations
  contains_one :address, :class => "Address"
  
  protected
  
  def self.findable_default_opts
    {}
  end
  
end
