module Resourceful
  module Model
    module ExternalAssociations
      
      module ClassMethods

        protected
        
        def has_many(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "has_many requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          find_method_name = (config.delete(:method) || 'find').to_s
          force = config.delete(:force) || false
          foreign_key_name = config.delete(:foreign_key) || "#{self.name.demodulize.underscore}_id"
          foreign_key_method = config.delete(:foreign_key_method) || 'id'
          Resourceful.add_to_associations(self.name, clean_name, {
            :type => :has_many,
            :class_name => class_name,
            :foreign_key_name => foreign_key_name,
            :foreign_key_method => foreign_key_method,
            :find_method_name => find_method_name
          })
          define_method(name) do |*args|
            reload = args.first || false
            if reload || (assoc_val = instance_variable_get("@#{clean_name}")).nil?
              klass = self.class.get_namespaced_klass(class_name)
              raise ArgumentError, "has_many :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
              unless klass.respond_to?(find_method_name)
                raise NotImplementedError, "has_many expects #{klass} to implement a Findable method named '#{find_method_name}'"
              end
              config[foreign_key_name] = self.send(foreign_key_method)
              instance_variable_set("@#{clean_name}", klass.send(find_method_name, :all, config, reload || force))
            else
              assoc_val
            end
          end
        end

        def belongs_to(name, config={})
          clean_name = cleanup_name(name)
          config ||= {}
          raise ArgumentError, "belongs_to requires a :class option to be specified" unless config[:class]
          class_name = config.delete(:class).to_s
          find_method_name = (config.delete(:method) || 'find').to_s
          force = config.delete(:force) || false
          foreign_key_name = config.delete(:foreign_key_name) || 'id'
          foreign_key_method = config.delete(:foreign_key) || "#{clean_name}_id"
          Resourceful.add_to_associations(self.name, clean_name, {
            :type => :belongs_to,
            :class_name => class_name,
            :foreign_key_name => foreign_key_name,
            :foreign_key_method => foreign_key_method,
            :find_method_name => find_method_name
          })
          define_method(name) do |*args|
            reload = args.first || false
            if reload || (assoc_val = instance_variable_get("@#{clean_name}")).nil?
              klass = self.class.get_namespaced_klass(class_name)
              raise ArgumentError, "belongs_to :class '#{class_name}' is not defined in any given namespaces" if klass.nil?
              unless self.respond_to?(foreign_key_method)
                raise ArgumentError, "belongs_to requires a '#{foreign_key_method}' method defined to return the foreign_key"
              end
              unless klass.respond_to?(find_method_name)
                raise NotImplementedError, "belongs_to expects #{klass} to implement a Findable method named '#{find_method_name}'"
              end
              fk = self.send(foreign_key_method)
              instance_variable_set("@#{clean_name}", fk.nil? || (fk.respond_to?('empty?') && fk.empty?) ? nil : klass.send(find_method_name, fk, config, reload || force))
            else
              assoc_val
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