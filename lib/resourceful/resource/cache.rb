module Resourceful
  module Resource
    class Cache

      attr_reader :store
      
      def self.key(host, verb, resource)
        "#{host}_#{verb}_#{resource}"
      end

      def initialize
        @store = {}
      end

      def clear(key=nil)
        if key
          @store[key] = nil
        else
          @store = {}
        end
      end
      
      def read(key)
        @store[key]
      end
      
      def write(key, value)
        @store[key] = value
      end

    end
  end
end