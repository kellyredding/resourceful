module Resourceful
  module Version
    
    MAJOR = 0
    MINOR = 4
    TINY  = 4
    
    def self.to_s # :nodoc:
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end