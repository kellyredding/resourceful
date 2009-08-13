module Resourceful
  module Model

    class Base
      
      @@agent ||= {}
      def self.agent(&block)
        @@agent[self.name.to_s] = block;
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
      
      def new_record?
        @data.nil?
      end
      
      def attributes(force=false)
        if @attributes.nil? || force
          @attributes = {}
          self.class.ancestors.each do |anc|
            if @@attributes[anc.to_s]
              @attributes.merge!(@@attributes[anc.to_s].inject({}) { |hsh, key| hsh[key] = self.send(key); hsh })
            end
          end
        end
        @attributes
      end
      
      def update_attributes(attr_hash={})
        attr_hash.each do |k,v|
          self.send("#{key}=", v)
        end
        attributes(true)
      end
      
      def save
        @data = yield attributes(true)
        reset_attributes
      end
      
      def destroy
        yield attributes(true)
        @data = nil
      end
      
      protected
      
      def push_data(verb, path, opts, data)
        block = opts.delete(:on_response)
        ['id', :id].each { |a| data.delete(a) } if data.kind_of?(::Hash)
        self.class.set_agent.send(verb.to_s, path, opts, data, &block)
      end
      
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
        define_method("#{name}=") do |value|
          instance_variable_set("@#{clean_name}", value)
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
      
      def reset_attributes
        clear_attributes
        attributes(true)
      end
      
      def clear_attributes
        @@attributes ||= {}
        klass_name = self.class.name
        @@attributes[klass_name] ||= []
        @@attributes[klass_name].each do |a|
          instance_variable_set("@#{a.to_s.gsub(/\W/,'')}", nil)
        end
      end
      
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
        klass_name = ""
        self.ancestors.each do |anc|
          if @@agent[anc.to_s]
            klass_name = anc.to_s 
            break
          end
        end
        
        unless @@agent[klass_name].kind_of?(Resourceful::Agent::Base)
          @@agent[klass_name] = @@agent[klass_name].call 
        end
        @@agent[klass_name]
      end

    end

  end
end