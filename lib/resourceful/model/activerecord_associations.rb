module Resourceful
  module Model
    module ExternalAssociations
      
      module ClassMethods

        protected
        
        def has_one_resourceful(name, config={})
          has_many(name, config).first
        end

        def has_many_resourceful(name, config={})
          clean_name = Resourceful::Model::Base.cleanup_name(name)
          config ||= {}
          raise ArgumentError, "has_many_resourceful requires a :class_name option to be specified" unless config[:class_name]
          class_name = config.delete(:class_name).to_s
          force = config.delete(:force) || true
          define_method(name) do
            klass = class_name.resourceful_constantize
            raise ArgumentError, "has_many_resourceful :class_name '#{class_name}' is not defined" if klass.nil?
            unless klass.respond_to?(:find)
              raise NotImplementedError, "has_many_resourceful expects #{klass} to be findable (ie mixin the Findable helper)"
            end
            fk = config.delete(:foreign_key) || "#{self.class.name.demodulize.underscore}_id"
            fk_method = config.delete(:foreign_key_method) || 'id'
            config[fk] = self.send(fk_method)
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                klass.find(:all, config, force)
              )
          end
        end

        def belongs_to_resourceful(name, config={})
          clean_name = Resourceful::Model::Base.cleanup_name(name)
          config ||= {}
          raise ArgumentError, "belongs_to_resourceful requires a :class_name option to be specified" unless config[:class_name]
          class_name = config.delete(:class_name).to_s
          foreign_key = config.delete(:foreign_key) || "#{clean_name}_id"
          force = config.delete(:force) || true
          define_method(name) do
            klass = class_name.resourceful_constantize
            raise ArgumentError, "belongs_to_resourceful :class_name '#{class_name}' is not defined" if klass.nil?
            unless self.respond_to?(foreign_key)
              raise ArgumentError, "belongs_to_resourceful requires a '#{foreign_key}' method defined to return the foreign_key"
            end
            unless klass.respond_to?(:find)
              raise NotImplementedError, "belongs_to_resourceful expects #{klass} to be findable (ie mixin the Findable helper)"
            end
            fk = self.send(foreign_key)
            if fk.nil? || (fk.respond_to?('empty?') && fk.empty?)
              nil
            else
              instance_variable_get("@#{clean_name}") || \
                instance_variable_set("@#{clean_name}", \
                  klass.find(fk, config, force)
                )
            end
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