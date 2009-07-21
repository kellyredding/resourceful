require 'nokogiri'
require 'json'

module Resourceful
  module Resource
    class Format
      
      SUPPORTED = ['json', 'xml']
      
      def self.get(format)
        raise Resourceful::Exceptions::FormatError, "the format '#{format}' is not supported" unless SUPPORTED.include?(format.to_s)
        self.send(format)
      end
      
      def self.json
        Resourceful::Resource::Json
      end
        
      def self.xml
        Resourceful::Resource::Xml
      end
      
      def self.to_s
        raise 'method not implemented by this format'
      end
        
      def self.build(str)
        raise 'method not implemented by this format'
      end
        
    end
  end
end

module Resourceful
  module Resource
    class Json < Resourceful::Resource::Format
      
      def self.to_s
        "json"
      end
        
      def self.build(json_str)
        Hash.from_json(json_str.to_s)
      end
        
    end
  end
end

module Resourceful
  module Resource
    class Xml < Resourceful::Resource::Format
      
      def self.to_s
        "xml"
      end
        
      def self.build(xml_str)
        Nokogiri::XML(xml_str.to_s)
      end
        
    end
  end
end
