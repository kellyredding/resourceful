module Resourceful
  module Shoulda
    module TestUnit
      
      def should_have_resourceful_attribute(name, opts={})
        clean_name = name.to_s.gsub(/\W/, '')
        should_have_instance_methods clean_name, "#{clean_name}=", "_#{clean_name}"
        # TODO: Validate this attribute is of type opts[:type] if provided
      end unless Test::Unit::TestCase.method_defined? :should_have_resourceful_attribute
      
      # Ripped from Shoulda::ActiveRecord::Macros
      def should_have_instance_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to instance method ##{method}" do
            assert_respond_to klass.new, method, "#{klass.name} does not have instance method #{method}"
          end
        end
      end unless Test::Unit::TestCase.method_defined? :should_have_instance_methods
      
    end
  end
end

Test::Unit::TestCase.extend(Resourceful::Shoulda::TestUnit) if defined? Test::Unit::TestCase
