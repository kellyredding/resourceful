class RestClientWidgetXml < Resourceful::Model::Xml
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.find(id)
    case id
    when :all
      get_collection("/widgets.xml", {}, "//widgets/widget")
    else
      get("/widgets/#{id}.xml", {}, "//widget")
    end
  end
  
  attribute :id, :integer
  attribute :name, :string

end

class RestClientWidgetJson < Resourceful::Model::Json
  
  agent do 
    WIDGETS_REST_CLIENT
  end
  
  def self.find(id, force=false)
    case id
    when :all
      get_collection("/widgets.json", {})
    else
      get("/widgets/#{id}.json", {})
    end
  end
  
  attribute :id, :integer
  attribute :name, :string
end
