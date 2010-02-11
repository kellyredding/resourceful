class Blog::Publisher < Resourceful::Model::Json
  
  add_namespace "Blog"
  agent do
    Resourceful::Agent::RestClient.new(:host => BLOG_HOST, :log_prefix => "Blog::Publisher")
  end
  
  include Resourceful::Model::Findable
  def self.findable_index
    "/publishers"
  end
  def findable_index
    self.class.findable_index
  end
  
  attribute :id, :integer
  attribute :name, :string
  
  include Resourceful::Model::ExternalAssociations  
  has_many :authors, :class => "Author"
  
  protected
  
  def self.findable_default_opts
    {}
  end
  
end
