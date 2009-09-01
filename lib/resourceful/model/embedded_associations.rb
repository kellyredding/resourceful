module Resourceful
  module Model
    module EmbeddedAssociations
      
      module ClassMethods

        protected
        
        def self.contains_one(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          config[:path] ||= clean_name
          define_method(name) do
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                if (c = child(config))
                  config[:class].constantize.new(c) rescue c
                else
                  c
                end
              )
          end
        end

        def self.contains_many(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          config[:path] ||= clean_name
          define_method(name) do
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                if ((c = child(config)) && c.respond_to?(:collect))
                  c.collect do |item|
                    config[:class].constantize.new(item) rescue item
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