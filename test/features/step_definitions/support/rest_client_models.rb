class RestClientWidgetXml < Resourceful::Model::Xml
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.item_path(id)
    "/widgets/#{id}.xml"
  end
  
  def self.find(id)
    case id
    when :all
      get_collection("/widgets.xml", {}, "//widgets/widget")
    else
      get(item_path(id), {}, "//widget")
    end
  end
  
  attribute :id, :integer
  attribute :name, :string
  
  def save
    super do |attribute_hash|
      self.send(new_record? ? "post" : "put", self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end
  
  def destroy
    super do |attribute_hash|
      self.delete(self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end

end

class RestClientWidgetJson < Resourceful::Model::Json
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.item_path(id)
    "/widgets/#{id}.json"
  end
  
  def self.find(id, force=false)
    case id
    when :all
      get_collection("/widgets.json", {})
    else
      get(item_path(id), {})
    end
  end
  
  attribute :id, :integer
  attribute :name, :string

  def save
    super do |attribute_hash|
      self.send(new_record? ? "post" : "put", self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end
  
  def destroy
    super do |attribute_hash|
      self.delete(self.class.item_path(id), {}, {:widget => attribute_hash})
    end
  end

end
