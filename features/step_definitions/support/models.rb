class UserXml < Resourceful::Model::Xml
  
  def self.find(screen_name, force=false)
    get("/users/#{screen_name}", {}, "//user")
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

class UserJson < Resourceful::Model::Json
  
  def self.find(screen_name, force=false)
    get("/users/#{screen_name}", {})
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

class StatusXml < Resourceful::Model::Xml
  
  def self.find(collection, force=false)
    get_collection("/statuses/#{collection}", {}, "//statuses/status")
  end
  
  attribute :id, :integer
  attribute :text, :string
  attribute :source, :string
  attribute :created_on, :date, :path => 'created_at'
  attribute :truncated, :boolean
  attribute :favorited, :boolean
  attribute :reply_status, :integer, :path => 'in_reply_to_status_id'
  attribute :reply_user, :integer, :path => 'in_reply_to_user_id'
  attribute :user_id, :integer, :path => "user/id"
  attribute :user_screen_name, :integer, :path => "user/screen_name"

  def user
    @user ||= (get_node('./user') ? UserXml.new(get_node('./user')) : nil)
  end
  
end

class StatusJson < Resourceful::Model::Json
  
  def self.find(collection, force=false)
    get_collection("/statuses/#{collection}", {})
  end
  
  attribute :id, :integer
  attribute :text, :string
  attribute :source, :string
  attribute :created_on, :date, :path => 'created_at'
  attribute :truncated, :boolean
  attribute :favorited, :boolean
  attribute :reply_status, :integer, :path => 'in_reply_to_status_id'
  attribute :reply_user, :integer, :path => 'in_reply_to_user_id'
  attribute :user_id, :integer, :path => "user/id"
  attribute :user_screen_name, :integer, :path => "user/screen_name"

  def user
    @user ||= UserXml.find(self.user_screen_name)
  end

end