module Resourceful
  module Resource
    class Cache

      attr_reader :store
      
      EXPIRY_SECS = 30
      
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
        entry = @store[key]
        expired?(entry) ? nil : entry[:value]
      end
      
      def write(key, value)
        @store[key] = {:value => value, :expires => Time.now.to_i + EXPIRY_SECS}
      end
      
      private
      
      def expired?(entry)
        (entry.nil? || !entry.kind_of?(::Hash) || entry[:expires] < Time.now.to_i)
        
      end

    end
  end
end