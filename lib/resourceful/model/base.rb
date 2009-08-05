module Resourceful
  module Model

    class Base
      
      @@agent = nil
      def self.agent(&block)
        @@agent = block;
      end
      
      def self.get(path, opts={})
        block = opts.delete(:on_response)
        set_agent.get(path, opts, &block)
      end
      def self.get_collection(path, opts={})
        block = opts.delete(:on_response)
        (yield set_agent.get(path, opts, &block)).collect{|data| new(data)}
      end

      def initialize(data)
      end
      
      protected
      
      def self.attribute(name, type, config={})
        config ||= {}
        config[:path] ||= name
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
          instance_variable_get("@#{name}") || \
            instance_variable_set("@#{name}", \
              if ((a = attribute(config)) && a.kind_of?(String))
                self.class.get_value(a, config).send(content_method)
              else
                a
              end
            )
        end
      end

      def self.has_one(name, config={})
        config ||= {}
        config[:path] ||= name
        define_method(name) do
          instance_variable_get("@#{name}") || \
            instance_variable_set("@#{name}", \
              if (c = child(config))
                config[:klass].constantize.new(c) rescue c
              else
                c
              end
            )
        end
      end

      def self.has_many(name, config={})
        config ||= {}
        config[:path] ||= name
        define_method(name) do
          instance_variable_get("@#{name}") || \
            instance_variable_set("@#{name}", \
              if ((c = child(config)) && c.respond_to?(:collect))
                c.collect do |item|
                  config[:klass].constantize.new(item) rescue item
                end
              else
                c
              end
            )
        end
      end

      def self.belongs_to(name, config={})
        config ||= {}
        config[:id] ||= "#{name}_id"
        define_method(name) do
          instance_variable_get("@#{name}") || \
            instance_variable_set("@#{name}", \
              if ((k = config[:klass].constantize) && k.respond_to?(:find))
                self.respond_to?(config[:id]) ? k.find(self.send(config[:id])) : nil
              else
                nil
              end
            )
        end
      end
      
      private
      
      def self.get_value(attribute, opts={})
        if opts[:value]
          (attribute =~ opts[:value]) ? ($1 || $&) : nil
        else
          attribute
        end
      end
      
      def self.set_agent
        unless @@agent.kind_of?(Resourceful::Agent::Base)
          @@agent = @@agent.call 
        end
        @@agent
      end

    end

  end
end