class RestClientWidgetXml < Resourceful::Model::Xml
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.collection_path
    "/widgets.xml"
  end
  
  def self.item_path(id)
    "/widgets/#{id}.xml"
  end
  
  def self.find(id)
    case id
    when :all
      get_collection(collection_path, {}, "//widgets/widget")
    else
      get(item_path(id), {}, "//widget")
    end
  end
  
  attribute :id, :integer
  attribute :name, :string
  
  def save
    super do |attribute_hash|
      if new_record?
        self.push_data('post', self.class.collection_path, {}, {:widget => attribute_hash})
      else
        self.push_data('put', self.class.item_path(id), {}, {:widget => attribute_hash})
      end
    end
  end
  
  def destroy
    super do |attribute_hash|
      self.push_data('delete', self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end

end

class RestClientWidgetJson < Resourceful::Model::Json
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.collection_path
    "/widgets.json"
  end
  
  def self.item_path(id)
    "/widgets/#{id}.json"
  end
  
  def self.find(id, force=false)
    case id
    when :all
      get_collection(collection_path, {})
    else
      get(item_path(id), {})
    end
  end
  
  attribute :id, :integer
  attribute :name, :string

  def save
    super do |attribute_hash|
      if new_record?
        self.push_data('post', self.class.collection_path, {}, {:widget => attribute_hash})
      else
        self.push_data('put', self.class.item_path(id), {}, {:widget => attribute_hash})
      end
    end
  end
  
  def destroy
    super do |attribute_hash|
      self.push_data('delete', self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end

end
