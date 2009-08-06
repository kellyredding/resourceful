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
      
      def data
        @data
      end
      
      def attributes
        @attributes ||= @@attributes[self.class.name].inject({}) { |hsh, key| hsh[key] = self.send(key); hsh }
      end
      
      protected
      
      def self.attribute(name, type, config={})
        clean_name = name.to_s.gsub(/\W/,'')
        add_to_attributes(name.to_s)
        config ||= {}
        config[:path] ||= clean_name
        content_method = case type.to_sym
        when :string
          'to_s'
        when :integer
          'to_i'
        when :float
          'to_f'
        when :currency
          'from_currency_to_f'
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
          instance_variable_get("@#{clean_name}") || \
            instance_variable_set("@#{clean_name}", \
              if ((a = attribute(config)) && a.kind_of?(String))
                self.class.get_value(a, config).send(content_method)
              else
                a
              end
            )
        end
      end

      def self.has_one(name, config={})
        clean_name = name.to_s.gsub(/\W/,'')
        config ||= {}
        config[:path] ||= clean_name
        define_method(name) do
          instance_variable_get("@#{clean_name}") || \
            instance_variable_set("@#{clean_name}", \
              if (c = child(config))
                config[:klass].constantize.new(c) rescue c
              else
                c
              end
            )
        end
      end

      def self.has_many(name, config={})
        clean_name = name.to_s.gsub(/\W/,'')
        config ||= {}
        config[:path] ||= clean_name
        define_method(name) do
          instance_variable_get("@#{clean_name}") || \
            instance_variable_set("@#{clean_name}", \
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
        clean_name = name.to_s.gsub(/\W/,'')
        config ||= {}
        config[:id] ||= "#{clean_name}_id"
        define_method(name) do
          instance_variable_get("@#{clean_name}") || \
            instance_variable_set("@#{clean_name}", \
              if ((k = config[:klass].constantize) && k.respond_to?(:find))
                self.respond_to?(config[:id]) ? k.find(self.send(config[:id])) : nil
              else
                nil
              end
            )
        end
      end
      
      private
      
      def self.add_to_attributes(name)
        @@attributes ||= {}
        klass_name = self.name
        @@attributes[klass_name] ||= []
        @@attributes[klass_name] << name
      end

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