require 'test/unit/assertions'
World(Test::Unit::Assertions)

RESOURCE_CONFIG = {
  :host => 'http://twitter.com',
  :resource => '/statuses/public_timeline',
  :params => {},
  :log => "./test.log"
}

require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'resourceful')

REST_CLIENT_TWITTER = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host])
MECHANIZE_TWITTER = Resourceful::Agent::Mechanize.new(:host => RESOURCE_CONFIG[:host])
