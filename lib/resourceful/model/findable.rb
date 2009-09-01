module Resourceful
  module Model
    module Findable
      
      module ClassMethods

        def find(id, opts={}, force=true)
          opts ||= {}
          opts = findable_default_opts.merge(opts) if respond_to?(:findable_default_opts)
          case id
          when :all
            self.get_collection("#{findable_index}.#{format}", opts, force)
          when :first
            self.get_collection("#{findable_index}.#{format}", opts, force).first
          else
            self.get("#{findable_index}/#{id}.#{format}", opts, force)
          end
        end
        
        def all
          find(:all)
        end
        def first
          find(:first)
        end
        
        def findable_index
          raise NotImplementedError, "Findable expects a public class method 'findable_index'"
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