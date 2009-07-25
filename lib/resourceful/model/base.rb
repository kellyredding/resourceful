module Resourceful
  module Model

    class Base
      
      @@agent = nil
      def self.agent(a)
        @@agent = a
      end
      
      def self.get(path, opts={})
        @@agent.get(path, opts)
      end
      def self.get_collection(path, opts={})
        (yield @@agent.get(path, opts)).collect{|data| new(data)}
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
          instance_variable_get("@#{name}") || instance_variable_set("@#{name}", ((a = attribute(config)) && a.kind_of?(String)) ? a.send(content_method) : a)
        end
      end

    end

  end
end