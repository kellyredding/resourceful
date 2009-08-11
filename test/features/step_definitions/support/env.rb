require 'test/unit/assertions'
World(Test::Unit::Assertions)

require File.join(File.dirname(__FILE__), 'widgets_controller.rb')

RESOURCE_CONFIG = {
  :host => WIDGETS_HOST,
  :resource => {
    :index => '/widgets',
    :item => '/widgets/1'
  },
  :params => {},
  :log => "./test.log"
}

require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'resourceful')

WIDGETS_REST_CLIENT = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host])
