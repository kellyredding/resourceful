require 'nokogiri'
require 'json'

module Resourceful; end

module Resourceful::Resource
  class Format
    
    SUPPORTED = ['json', 'xml']
    
    class << self
      
      def get(format)
        raise Resourceful::Exceptions::FormatError, "the format '#{format}' is not supported" unless SUPPORTED.include?(format.to_s)
        self.send(format)
      end

      def json
        Resourceful::Resource::Json
      end

      def xml
        Resourceful::Resource::Xml
      end

      def to_s
        raise 'method not implemented by this format'
      end

      def build(str)
        raise 'method not implemented by this format'
      end
      
      protected
      
      def parsable?(data)
        if !data.nil? && !data.to_s.strip.empty? && data.to_s.strip != 'null'
          yield if block_given?
        else
          nil
        end
      end

    end
    
  end
end

module Resourceful::Resource
  class Json < Resourceful::Resource::Format
    
    class << self

      def to_s
        "json"
      end

      def build(json_str)
        parsable?(json_str) do
          JSON.parse(json_str.to_s.strip)
        end
      end

    end    
      
  end
end

module Resourceful::Resource
  class Xml < Resourceful::Resource::Format
    
    class << self
    
      def to_s
        "xml"
      end

      def build(xml_str)
        parsable?(xml_str) do
          Nokogiri::XML(xml_str.to_s)
        end
      end

    end
    
  end
end
