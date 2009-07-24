module Resourceful
  module Model

    class Base
      
      # KDR: override this to have a per model Resource handler
      # => TODO: need to support creating resource instances first though
      def self.resource
        Resourceful::Resource
      end
      
      def self.find(path, opts={}, force=false)
        resource.get(path, opts, force)
      end
      def self.find_collection(path, opts={}, force=false)
        (yield resource.get(path, opts, force)).collect{|data| new(data)}
      end

      def initialize(data)
      end
      
      protected
      
      def self.attribute(name, type, config)
        content_method = case type.to_sym
        when :string
          'to_s'
        when :integer
          'to_i'
        when :float
          'to_f'
        when :date
          'to_date'
        when :datetime
          'to_datetime'
        when :boolean
          'to_boolean'
        else 
          'to_s'
        end
        define_method(name) do
          instance_variable_get("@#{name}") || instance_variable_set("@#{name}", (a = attribute(config)).kind_of?(String) ? a.send(content_method) : a)
        end
      end

    end

  end
end