class Widget
  # this is a dummy AR-like model for use in the test "widget_controller.rb"
  
  ATTRS = [:id, :name]
  WIDGETS = [
    {
      :id => 1,
      :name => 'One'
    },
    {
      :id => 2,
      :name => 'Two'
    },
    {
      :id => 3,
      :name => 'Three'
    },
    {
      :id => 4,
      :name => 'Four'
    },
    {
      :id => 5,
      :name => 'Five'
    },
    {
      :id => true,
      :name => 'TrueClass'
    },
    {
      :id => false,
      :name => 'FalseClass'
    },
    {
      :id => Time.now,
      :name => 'Time Now'
    }
  ]
  
  ATTRS.each { |attribute| attr_accessor attribute }
  
  def self.all
    WIDGETS.collect{ |params| new(params) }
  end
  
  def self.find(id)
    new(WIDGETS[id.to_i-1])
  end
  
  def initialize(params={})
    update_attributes(params)
  end
  
  def update_attributes(params={})
    params = {} if params.nil? || params.empty?
    ATTRS.each { |attribute| instance_variable_set("@#{attribute.to_s}", params[attribute]) }
  end
      
  def save
    true
  end
  
  def destroy
    true
  end
  
  def to_xml(args={})
    {:id => @id, :name => @name}.to_xml(args)
  end
  
  def to_json(args={})
    {:id => @id, :name => @name}.to_json
  end
  
end
