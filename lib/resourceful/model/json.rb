module Resourceful
  module Model

    class Json < Resourceful::Model::Base
      
      attr_reader :json

      def self.get(path, params, force=false)
        opts = {
          :format => 'json',
          :params => params || {}
        }
        new(super(path, opts, force))
      end
      def self.get_collection(path, params, force=false)
        opts = {
          :format => 'json',
          :params => params || {}
        }
        super(path, opts, force) do |data|
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
        paths.inject(@json) do |val,path|
          #raise Resourceful::Exceptions::AttributeError, "no matching attribute data for'#{config[:path]}'" if val.nil?
          val.fetch(path, nil) rescue nil
        end
      end
        

    end

  end
end