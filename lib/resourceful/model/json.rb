require "resourceful/model/base"

module Resourceful
  module Model

    class Json < Resourceful::Model::Base
      
      attr_reader :json

      def self.get(path, params, search=nil, force=false, &block)
        opts = {
          :format => 'json',
          :params => params || {},
          :force => force,
          :on_response => block
        }
        result = super(path, opts)
        hsh_keys = search.kind_of?(String) ? search.split(/\s+/) : nil
        new(!hsh_keys.nil? && !hsh_keys.empty? && result.respond_to?(:get_value) ? result.get_value(hsh_keys) : result)
      end
      def self.get_collection(path, params, search=nil, force=false, &block)
        opts = {
          :format => 'json',
          :params => params || {},
          :force => force,
          :on_response => block
        }
        hsh_keys = search.kind_of?(String) ? search.split(/\s+/) : nil
        super(path, opts) do |data|
          data.collect{|item| !hsh_keys.nil? && !hsh_keys.empty? && item.respond_to?(:get_value) ? item.get_value(hsh_keys) : item}
        end
      end

      def initialize(json=nil)
        raise Resourceful::Exceptions::ModelError, "trying to initialize a Resourceful::Model::Json model with '#{json.class.name}' data" unless json.nil? || json.kind_of?(::Hash)
        @data = json
      end
      
      protected
      
      def self.format
        Resourceful::Resource::Json.to_s
      end
      
      def attribute(config)
        begin
          get_node(config[:path])
        rescue Exception => err
          nil
        end
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