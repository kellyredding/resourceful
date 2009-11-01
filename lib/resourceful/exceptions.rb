module Resourceful; end

module Resourceful::Exceptions

  class ResourcefulError < ::StandardError
  end
  
  class ResourceError < ResourcefulError
  end
  
  class ConfigurationError < ResourceError
  end
  
  class FormatError < ResourceError
  end
  
  class ModelError < ResourcefulError
  end
  
  class AttributeError < ModelError
  end
    
end