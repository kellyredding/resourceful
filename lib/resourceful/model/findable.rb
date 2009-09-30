module Resourceful
  module Model
    module Findable
      
      module ClassMethods

        def find(id, opts={}, force=false)
          opts ||= {}
          opts = findable_default_opts.merge(opts) if respond_to?(:findable_default_opts)
          case id
          when :all
            self.get_collection("#{findable_index}.#{format}", opts, findable_search, force)
          when :first
            self.get_collection("#{findable_index}.#{format}", opts, findable_search, force).first
          when :last
            self.get_collection("#{findable_index}.#{format}", opts, findable_search, force).last
          else
            self.get("#{findable_index}/#{id}.#{format}", opts, findable_search, force)
          end
        end
        
        def all
          find(:all)
        end
        def first
          find(:first)
        end
        def last
          find(:last)
        end
        
        def findable_index
          raise NotImplementedError, "Findable expects a public class method 'findable_index'"
        end
        
        def findable_search
          # defaults to non namespaced downcased name of the class
          self.name.demodulize.underscore.to_s.gsub(/^.*::/, '')
        end
        
      end
      
      module InstanceMethods
        
        def save
          super do |attribute_hash|
            if new_record?
              self.push_data('post', \
                "#{self.class.findable_index}.#{self.class.format}", \
                {:params => self.class.findable_default_opts.merge(push_data_params)}, \
                nested_attr_hash(attribute_hash), \
                self.class.findable_search \
              )
            else
              self.push_data('put', \
                "#{self.class.findable_index}/#{self.id}.#{self.class.format}", \
                {:params => self.class.findable_default_opts.merge(push_data_params)}, \
                nested_attr_hash(attribute_hash), \
                self.class.findable_search \
              )
            end
          end
        end
        
        def destroy
          super do |attribute_hash|
            unless new_record?
              self.push_data('delete', \
                "#{self.class.findable_index}/#{self.id}.#{self.class.format}", \
                {:params => self.class.findable_default_opts.merge(push_data_params)}, \
                {} \
              )
            end
          end
        end
        
        def push_data_params
          # override to customize save url params
          {}
        end
        
        def push_data_nesting
          # default, override to customize, set to nil for push data hash style nesting
          self.class.name.demodulize.underscore
        end
        
        private
        
        def nested_attr_hash(attr_hash)
          push_data_nesting ? {push_data_nesting => attr_hash} : attr_hash
        end
        
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
      
    end
  end
end