module Resourceful
  module Model
    module AttributeTypes
      
      module ClassMethods
        
        ATTRIBUTE_TYPES = {
          :string   => { :method => 'to_s',                   :kind => ::String   },
          :text     => { :method => 'to_s',                   :kind => ::String   },
          :integer  => { :method => 'to_i',                   :kind => ::Fixnum   },
          :float    => { :method => 'to_f',                   :kind => ::Float    },
          :currency => { :method => 'from_currency_to_f',     :kind => ::Float    },
          :date     => { :method => 'to_date',                :kind => ::Date     },
          :datetime => { :method => 'to_datetime',            :kind => ::DateTime },
          :boolean  => { :method => 'to_resourceful_boolean', :kind => ::Object   },
          :other    => { :method => 'to_s',                   :kind => ::String   }
        }
        
        def attribute_type_to_method(type)
          (ATTRIBUTE_TYPES.has_key?(type.to_sym) ? ATTRIBUTE_TYPES[type.to_sym] : ATTRIBUTE_TYPES[:other])[:method]
        end

        def attribute_type_to_kind(type)
          (ATTRIBUTE_TYPES.has_key?(type.to_sym) ? ATTRIBUTE_TYPES[type.to_sym] : ATTRIBUTE_TYPES[:other])[:kind]
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