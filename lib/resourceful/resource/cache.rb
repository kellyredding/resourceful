module Resourceful; end

module Resourceful::Resource
    
  class Cache

    attr_reader :store, :expiration
    
    EXPIRY_SECS = 60
    
    def self.key(host, verb, resource)
      "#{host}_#{verb}_#{resource}"
    end

    def initialize(expiration=EXPIRY_SECS)
      @expiration = (expiration && expiration.kind_of?(::Fixnum)) ? expiration : EXPIRY_SECS
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
      @store[key] = {:value => value, :expires => Time.now.to_i + @expiration}
      value
    end
    
    private
    
    def expired?(entry)
      (entry.nil? || !entry.kind_of?(::Hash) || entry[:expires] < Time.now.to_i)
      
    end

  end
end