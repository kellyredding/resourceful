require "resourceful/model/base"

module Resourceful; end

module Resourceful::Model

  class Json < Resourceful::Model::Base
    
    attr_reader :json

    def self.get(path, params, search=nil, force=false, &block)
      opts = {
        :format => 'json',
        :params => params || {},
        :force => force,
        :on_response => block
      }
      new(get_result_data(super(path, opts), search))
    end
    def self.get_collection(path, params, search=nil, force=false, &block)
      opts = {
        :format => 'json',
        :params => params || {},
        :force => force,
        :on_response => block
      }
      super(path, opts) do |data|
        data.collect {|item| get_result_data(item, search) }
      end
    end

    def initialize(json=nil)
      raise Resourceful::Exceptions::ModelError, "trying to initialize a Resourceful::Model::Json model with '#{json.class.name}' data" unless json.nil? || json.kind_of?(::Hash)
      @data = json
    end
    
    protected
    
    def push_data(verb, path, opts, data, search=nil)
      self.class.get_result_data(super(verb, path, opts, data), search)
    end
    
    def self.get_result_data(result, search)
      hsh_keys = search.kind_of?(String) ? search.split(/\s+/) : nil
      result_data = !hsh_keys.nil? && !hsh_keys.empty? && result.respond_to?(:get_value) ? (result.get_value(hsh_keys) || result) : result
    end
    
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
