module Resourceful
  module Resource
    
    # The idea here is to take a collection of object instances that have resourceful associations and
    # => for each association specified
    # => get the foreign keys for each item in the collection
    #   => grab the data for all the foreign keys in one call
    #   => for each item in the collection, build it's association value from the group data
    def self.eager_load(collection, associations=[])
      foreign_keys
    end
    
  end
end