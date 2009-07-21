require 'test/unit/assertions'
World(Test::Unit::Assertions)

RESOURCE_CONFIG = {
  :host => 'twitter.com',
  :resource => '/statuses/public_timeline',
  :params => {},
  :log => "./test.log"
}

require File.dirname(__FILE__) + '/../../../lib/resourceful'
