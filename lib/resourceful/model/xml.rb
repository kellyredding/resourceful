module Resourceful
  module Model

    class Xml < Resourceful::Model::Base
      
      attr_reader :xml

      def self.get(path, params, xpath, force=false)
        opts = {
          :format => 'xml',
          :params => params || {},
          :force => force
        }
        new(super(path, opts).xpath(xpath))
      end
      def self.get_collection(path, params, xpath, force=false)
        opts = {
          :format => 'xml',
          :params => params || {},
          :force => force
        }
        super(path, opts) do |data|
          data.xpath(xpath)
        end
      end

      def initialize(xml)
        raise Resourceful::Exceptions::ModelError, "trying to initialize a Resourceful::Model::Xml model with '#{xml.class.name}' data" unless xml.kind_of?(Nokogiri::XML::NodeSet) || xml.kind_of?(Nokogiri::XML::Element)
        @data = xml
      end
      
      protected
      
      def self.attribute(name, type, config={})
        super(name, type, config)
      end
      
      def attribute(config)
        begin
          get_node("./#{config[:path]}").content
        rescue Exception => err
          nil
        end          
      end
        
      def self.has_one(name, config={})
        super(name, config)
      end
      
      def child(config)
        begin
          get_node("./#{config[:path]}")
        rescue Exception => err
          nil
        end
      end
        
      def self.get_node(xml, path)
        xml.xpath(path.to_s).first
      end
      def get_node(path)
        self.class.get_node(@data, path)
      end

      def self.xml_root_name(xml)
        xml.root.name
      end
      def xml_root_name
        self.class.xml_root_name(@data)
      end

    end

  end
end