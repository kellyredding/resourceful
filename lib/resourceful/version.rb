module Resourceful
  module Version
    
    MAJOR = 0
    MINOR = 6
    TINY  = 5
    
    def self.to_s # :nodoc:
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end