require 'resourceful/model/base'
require 'resourceful/extensions'

module Resourceful
  module Shoulda
    module TestUnit
      
      def should_have_resourceful_attribute(name, opts={})
        clean_name = ::Resourceful::Model::Base.cleanup_name(name)
        should_have_instance_methods clean_name, "#{clean_name}=", "_#{clean_name}"
        # TODO: Validate this attribute is of type opts[:type] if provided
      end unless Test::Unit::TestCase.method_defined? :should_have_resourceful_attribute
      
      def should_have_namespace(ns)
        klass = described_type
        should "have the namespace '#{ns}' configured" do
          assert klass.namespaces.include?(ns), "#{klass} does not have the '#{ns}' namespace"
        end
      end
      
      def should_be_findable(index)
        should_have_class_methods :find
        klass = described_type
        should "have '#{index}' as a findable index" do
          assert_equal index, klass.findable_index, "#{klass} findable index is not '#{index}'"
        end
      end
      
      def should_resourcefully_belong_to(name, opts={})
        clean_name = ::Resourceful::Model::Base.cleanup_name(name)
        should_have_instance_methods clean_name
        # TODO: Validation :class config present, validation that a namespaced klass is defined
        # TODO: Validate it returns something of that klass
      end
      
      def should_resourcefully_have_many(name, opts={})
        clean_name = ::Resourceful::Model::Base.cleanup_name(name)
        should_have_instance_methods clean_name
        # TODO: Validation :class config present, validation that a namespaced klass is defined
        # TODO: Validate returns an array of items of that klass
      end
      
      def should_resourcefully_contain_one(name, opts={})
        clean_name = ::Resourceful::Model::Base.cleanup_name(name)
        should_have_instance_methods clean_name
        # TODO: Validation :class config present, validation that a namespaced klass is defined
        # TODO: Validate it returns something of that klass
      end
      
      def should_resourcefully_contain_many(name, opts={})
        clean_name = ::Resourceful::Model::Base.cleanup_name(name)
        should_have_instance_methods clean_name
        # TODO: Validation :class config present, validation that a namespaced klass is defined
        # TODO: Validate returns an array of items of that klass
      end
      
      protected
      
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
      
      # Ripped from Shoulda::ActiveRecord::Macros
      def should_have_class_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to class method ##{method}" do
            assert_respond_to klass, method, "#{klass.name} does not have class method #{method}"
          end
        end
      end
      
    end
  end
end

Test::Unit::TestCase.extend(Resourceful::Shoulda::TestUnit) if defined? Test::Unit::TestCase
