module Resourceful
  module Model
    module EmbeddedAssociations
      
      module ClassMethods

        protected
        
        def contains_one(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          config[:path] ||= clean_name
          raise ArgumentError, "contains_one requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          define_method(name) do
            klass = self.class.get_namespaced_klass(class_name)
            raise ArgumentError, "contains_one :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                if (c = child(config))
                  klass.new(c) rescue c
                else
                  c
                end
              )
          end
        end

        def contains_many(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          config[:path] ||= clean_name
          raise ArgumentError, "contains_many requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          define_method(name) do
            klass = self.class.get_namespaced_klass(class_name)
            raise ArgumentError, "contains_many :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                if ((c = child(config)) && c.respond_to?(:collect))
                  c.collect do |item|
                    klass.new(item) rescue item
                  end
                else
                  c
                end
              )
          end
        end

      end
      
      module InstanceMethods
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
      
    end
  end
end