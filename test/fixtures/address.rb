class Blog::Address < Resourceful::Model::Json
  
  attribute :street, :string
  attribute :city, :string
  attribute :state, :string
  
end
