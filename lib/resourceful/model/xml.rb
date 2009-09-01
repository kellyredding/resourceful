require File.join(File.dirname(__FILE__), 'base.rb')

module Resourceful
  module Model

    class Xml < Resourceful::Model::Base
      
      attr_reader :xml

      def self.get(path, params, search, force=false, &block)
        opts = {
          :format => 'xml',
          :params => params || {},
          :force => force,
          :on_response => block
        }
        new(super(path, opts).search(search))
      end
      def self.get_collection(path, params, search, force=false, &block)
        opts = {
          :format => 'xml',
          :params => params || {},
          :force => force,
          :on_response => block
        }
        super(path, opts) do |data|
          data.search(search)
        end
      end

      def initialize(xml=nil)
        raise Resourceful::Exceptions::ModelError, "trying to initialize a Resourceful::Model::Xml model with '#{xml.class.name}' data" unless xml.nil? || xml.kind_of?(Nokogiri::XML::NodeSet) || xml.kind_of?(Nokogiri::XML::Element)
        @data = xml
      end
      
      protected
      
      def self.format
        Resourceful::Resource::Xml.to_s
      end
      
      def attribute(config)
        begin
          get_node(config[:path]).first.send((config[:content] || 'content').to_s)
        rescue Exception => err
          nil
        end          
      end
        
      def child(config)
        begin
          get_node(config[:path])
        rescue Exception => err
          nil
        end
      end
        
      def self.get_node(xml, path)
        xml.search(path.to_s)
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