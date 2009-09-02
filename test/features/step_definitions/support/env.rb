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

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'resourceful'

WIDGETS_REST_CLIENT = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host])
