class Blog::Comment < Resourceful::Model::Xml
    
  attribute :user_name, :string, :path => 'user-name'
  attribute :text, :string
  attribute :count, :integer
  attribute :average, :float
  attribute :cost, :currency
  attribute :on, :date
  attribute :at, :datetime
  attribute :valid, :boolean
  
  attribute :text_type, :string, :path => "text/@type"
  attribute :text_key, :integer, :path => "text/@key", :value => /integer-([0-9]+)/
  attribute :line_one, :string, :path => "line[@class='one']"
  attribute :two_line, :boolean, :path => "line[@class='two']"
  alias_method 'two_line?', 'two_line'
  attribute :three_line, :boolean, :path => "line[@class='three']"
  alias_method 'three_line?', 'three_line'

end
