module Resourceful
  module Model

    class Json < Resourceful::Model::Base
      
      attr_reader :json

      def self.get(path, params, force=false)
        opts = {
          :format => 'json',
          :params => params || {},
          :force => force
        }
        new(super(path, opts))
      end
      def self.get_collection(path, params, force=false)
        opts = {
          :format => 'json',
          :params => params || {},
          :force => force
        }
        super(path, opts) do |data|
          data
        end
      end

      def initialize(json)
        raise Resourceful::Exceptions::ModelError, "trying to initialize a Resourceful::Model::Json model with '#{json.class.name}' data" unless json.kind_of?(::Hash)
        @data = json
      end
      
      protected
      
      def self.attribute(name, type, config={})
        super(name, type, config)
      end
      
      def attribute(config)
        begin
          get_node(config[:path])
        rescue Exception => err
          nil
        end
      end        

      def self.has_one(name, config={})
        super(name, config)
      end
      
      def child(config)
        attribute(config)
      end
        
      def self.get_node(json, path_config)
        paths = path_config.to_s.split('/')
        paths.inject(json) { |val,path| val.fetch(path, nil) rescue nil }
      end
      def get_node(path_config)
        self.class.get_node(@data, path_config)
      end
    end

  end
end