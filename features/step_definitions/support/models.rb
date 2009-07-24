class UserXml < Resourceful::Model::Xml
  
  def self.find(screen_name, force=false)
    super("/users/#{screen_name}", {}, "//user")
  end
  
  attribute :id, :integer
  attribute :name, :string
  attribute :screen_name, :string
  attribute :location, :string
  attribute :description, :string
  attribute :profile_image_url, :string
  attribute :url, :string
  attribute :protected, :boolean
  attribute :followers_count, :integer
  attribute :friends_count, :integer
  attribute :created_on, :date, :path => 'created_at'
  attribute :last_status_at, :datetime, :path => "status/created_at"
  attribute :last_status, :string, :path => "status/text"

end