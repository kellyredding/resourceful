module Resourceful
  module Model
    module ExternalAssociations
      
      module ClassMethods

        protected
        
        def has_one(name, config={})
          has_many(name, config).first
        end

        def has_many(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "has_many requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          force = config.delete(:force) || true
          define_method(name) do
            klass = self.class.get_namespaced_klass(class_name)
            raise ArgumentError, "has_many :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
            unless klass.respond_to?(:find)
              raise NotImplementedError, "has_many expects #{klass} to be findable (ie mixin the Findable helper)"
            end
            fk = config.delete(:foreign_key) || "#{self.class.name.downcase.to_s.gsub(/^.*::/, '')}_id"
            fk_method = config.delete(:foreign_key_method) || 'id'
            config[fk] = self.send(fk_method)
            instance_variable_get("@#{clean_name}") || \
              instance_variable_set("@#{clean_name}", \
                klass.find(:all, config, force)
              )
          end
        end

        def belongs_to(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "belongs_to requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          foreign_key = config.delete(:foreign_key) || "#{clean_name}_id"
          force = config.delete(:force) || true
          define_method(name) do
            klass = self.class.get_namespaced_klass(class_name)
            raise ArgumentError, "belongs_to :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
            unless self.respond_to?(foreign_key)
              raise ArgumentError, "belongs_to requires a '#{foreign_key}' method defined to return the foreign_key"
            end
            unless klass.respond_to?(:find)
              raise NotImplementedError, "has_many expects #{klass} to be findable (ie mixin the Findable helper)"
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