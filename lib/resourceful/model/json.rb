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
        @json = json
      end
      
      protected
      
      def self.attribute(name, type, config={})
        config[:path] ||= name
        super(name, type, config)
      end
      
      def attribute(config)
        paths = config[:path].to_s.split('/')
        paths.inject(@json) { |val,path| val.fetch(path, nil) rescue nil }
      end
        

    end

  end
end