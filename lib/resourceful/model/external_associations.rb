module Resourceful
  module Model
    module ExternalAssociations
      
      module ClassMethods

        protected
        
        def has_one(name, config={})
          has_many(name, config).first
        end

        def self.has_many(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "has_many requires a :class option to be specified" unless config[:class]
          klass = config.delete(:class)
          force = config.delete(:force) || true
          define_method(name) do
            unless klass.to_s.constantize.respond_to?(:find)
              raise NotImplementedError, "has_many expects #{klass} to be findable (ie mixin the Findable helper)"
            end
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                klass.to_s.constantize.find(:all, config, force)
              )
          end
        end

        def self.belongs_to(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "has_many requires a :class option to be specified" unless config[:class]
          klass = config.delete(:class)
          foreign_key = config.delete(:foreign_key) || "#{clean_name}_id"
          force = config.delete(:force) || true
          define_method(name) do
            unless self.respond_to?(foreign_key)
              raise ArgumentError, "belongs_to requires a '#{foreign_key}' method defined to return the foreign_key"
            end
            unless klass.to_s.constantize.respond_to?(:find)
              raise NotImplementedError, "has_many expects #{klass} to be findable (ie mixin the Findable helper)"
            end
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                klass.to_s.constantize.find(self.send(foreign_key), config, force)
              )
          end
        end

      end
      
      module InstanceMethods
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.send :include, Resourceful::Model::Findable
      end
      
    end
  end
end