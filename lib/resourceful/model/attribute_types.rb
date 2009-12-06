module Resourceful; end
module Resourceful::Model; end

module Resourceful::Model::AttributeTypes
      
  module ClassMethods
    
    ATTRIBUTE_TYPES = {
      :string   => { :method => 'to_s',               :kind => ::String   },
      :text     => { :method => 'to_s',               :kind => ::String   },
      :integer  => { :method => 'to_i',               :kind => ::Fixnum   },
      :float    => { :method => 'to_f',               :kind => ::Float    },
      :currency => { :method => 'from_currency_to_f', :kind => ::Float    },
      :date     => { :method => 'to_date',            :kind => ::Date     },
      :datetime => { :method => 'to_datetime',        :kind => ::DateTime },
      :time     => { :method => 'to_time_at',         :kind => ::Time     },
      :boolean  => { :method => 'to_boolean',         :kind => ::Object   },
      :other    => { :method => 'to_s',               :kind => ::String   }
    }
    
    def attribute_type_to_method(type)
      get_attribute_type_config(type)[:method]
    end

    def attribute_type_to_kind(type)
      get_attribute_type_config(type)[:kind]
    end
    
    private
    
    def get_attribute_type_config(type)
      ATTRIBUTE_TYPES.has_key?(type.to_sym) ? ATTRIBUTE_TYPES[type.to_sym] : ATTRIBUTE_TYPES[:other]
    end

  end
  
  module InstanceMethods
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
  
end
