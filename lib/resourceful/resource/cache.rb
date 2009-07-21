module Resourceful
  module Resource
    class Cache

      @@cache = {}

      def self.clear(key=nil)
        if key
          @@cache[key] = nil
        else
          @@cache = {}
        end
      end
      
      def self.read(key)
        @@cache[key]
      end
      
      def self.write(key, value)
        @@cache[key] = value
      end

      def self.key(server, verb, path, format, params)
        "#{server}_#{verb}_#{path}_#{format.to_s}_#{params.to_s}"
      end
      
      attr_reader :key
      
      def initialize(server, verb, path, format, params)
        @key = self.class.key(server, verb, path, format, params)
      end
      
      def read
        self.class.read(@key)
      end
      
      def write(value)
        self.class.write(@key, value)
      end
      
      def clear
        self.class.clear(@key)
      end

    end
  end
end