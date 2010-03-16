module Resourceful; end
module Resourceful::Extensions; end

module Resourceful::Extensions::String
  
  module ClassMethods
  end
  
  module InstanceMethods

    # Had to use a custom version of constantize to get around rails enhancements of 'const_missing'
    # => instead, I just raise an uninitialized constant NameError manually
    unless "".respond_to?(:resourceful_constantize) 
      if Module.method(:const_get).arity == 1
        def resourceful_constantize #:nodoc:
          names = self.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = ::Object
          names.each do |name|
            constant = constant.const_defined?(name) ? constant.const_get(name) : raise(NameError.new("uninitialized constant #{self}"))
          end
          constant
        end
      else # Ruby 1.9 version
        def resourceful_constantize #:nodoc:
          names = self.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = ::Object
          names.each do |name|
            constant = constant.const_get(name, false) || raise(NameError.new("uninitialized constant #{self}"))
          end
          constant
        end
      end
    end

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end      

class String
  include Resourceful::Extensions::String
end

