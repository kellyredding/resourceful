require 'useful/shoulda_macros/test_unit'
require 'resourceful/model/base'
require 'resourceful/extensions'

module Resourceful; end
module Resourceful::Shoulda; end

module Resourceful::Shoulda::TestUnit
  
  protected
  
  def should_have_resourceful_attribute(name, opts={})
    clean_name = ::Resourceful::Model::Base.cleanup_name(name)
    should_have_instance_methods clean_name, "#{clean_name}=", "_#{clean_name}"
    should_have_resourceful_typed_attribute(name, opts[:type])
  end unless Test::Unit::TestCase.method_defined? :should_have_resourceful_attribute
  
  def should_have_namespace(ns)
    klass = described_type
    should "have the namespace '#{ns}' configured" do
      assert klass.namespaces.include?(ns), "#{klass} does not have the '#{ns}' namespace"
    end
  end
  
  def should_be_findable(index)
    should_have_class_methods :find
    should_have_instance_methods :save, :destroy
    klass = described_type
    should "have '#{index}' as a findable index" do
      assert_equal index, klass.findable_index, "#{klass} findable index is not '#{index}'"
    end
  end
  
  def should_resourcefully_belong_to(name, opts={})
    clean_name = ::Resourceful::Model::Base.cleanup_name(name)
    should_have_instance_methods clean_name
    should_have_resourceful_association_item(name, opts)
  end
  
  def should_resourcefully_have_many(name, opts={})
    clean_name = ::Resourceful::Model::Base.cleanup_name(name)
    should_have_instance_methods clean_name
    should_have_resourceful_association_collection(name, opts)
  end
  
  def should_resourcefully_contain_one(name, opts={})
    clean_name = ::Resourceful::Model::Base.cleanup_name(name)
    should_have_instance_methods clean_name
    should_have_resourceful_association_item(name, opts)
  end
  
  def should_resourcefully_contain_many(name, opts={})
    clean_name = ::Resourceful::Model::Base.cleanup_name(name)
    should_have_instance_methods clean_name
    should_have_resourceful_association_collection(name, opts)
  end




  private  # Helpers ***************************************
  
  def should_have_resourceful_typed_attribute(name, type)
    if type
      should "have a #{name} resourceful #{type} value" do
        if subject && (val = subject.send(name))
          assert_kind_of Resourceful::Model::Base.attribute_type_to_kind(type), val, "#{name} does not have a #{Resourceful::Model::Base.attribute_type_to_kind(type)} kind of value."
        end
      end
    end
  end
  
  def should_have_resourceful_association_item(name, opts)
    klass = described_type
    should_have_resourceful_association_class(name, opts)
    should "return an item that is of the correct class" do
      if subject && (val = subject.send(name))
        class_name = if !!opts[:polymorphic]
          val.send("#{name}_type")
        else
          opts[:class]
        end
        assert_kind_of klass.get_namespaced_klass(class_name), val, "#{name} should be a kind of #{class_name}"
      end
    end
  end
  
  def should_have_resourceful_association_collection(name, opts)
    klass = described_type
    should_have_resourceful_association_class(name, opts)
    should "return a collection of items that are a kind of #{opts[:class]}" do
      if subject && (val = subject.send(name))
        assert_kind_of ::Array, val, "#{name} should be a kind of Array"
        if (first_item = val.first)
          assert_kind_of klass.get_namespaced_klass(opts[:class]), first_item, "#{name} first item should be a kind of #{opts[:class]}"
        end
      end
    end
  end
  
  def should_have_resourceful_association_class(name, opts)
    # TODO: update this for polymorphic
    klass = described_type
    should "have a #{opts[:class]} class specified that is defined" do
      class_name = if !!opts[:polymorphic]
        subject.send("#{name}_type")
      else
        opts[:class]
      end
      assert class_name, "resourceful can't determine the class name from either the :class option or a :polymorphic setting"
      assert klass.get_namespaced_klass(class_name), "a namespaced #{class_name} is not defined"
    end
  end
  
end

Test::Unit::TestCase.extend(Resourceful::Shoulda::TestUnit) if defined? Test::Unit::TestCase
