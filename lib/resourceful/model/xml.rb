module Resourceful
  module Model

    class Xml
      
      attr_reader :xml

      def self.find(path, params, xpath, force=false)
        opts = {
          :format => 'xml',
          :params => params || {}
        }
        new(super(path, opts, force).xpath(xpath))
      end
      def self.find_collection(path, params, xpath, force=false)
        super(path, opts, force) do |data|
          data.xpath(xpath)
        end
      end

      def initialize(xml)
        @xml = xml
      end
      
      protected
      
      def self.attribute(name, type, config)
        raise Resourceful::AttributeError, "no path provided for selecting the attribute '#{name}'." unless config[:path]
        super(name, type, config) do
          get_node("./#{config[:path]}").content
        end
      end
      def self.get_node(xml, path)
        xml.xpath(path.to_s).first
      end
      def get_node(path)
        self.class.get_node(@xml, path)
      end

      def self.xml_root_name(xml)
        xml.root.name
      end
      def xml_root_name
        self.class.xml_root_name(@xml)
      end

    end

  end
end