# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'resourceful'

# Setup fakeweb objects for testing purposes

Dir[File.join(File.dirname(__FILE__), "support" ,"*.rb")].each do |file|
  require file
end

RESOURCE_CONFIG = {
  :host => WIDGETS_HOST,
  :resource => {
    :index => '/widgets',
    :item => '/widgets/1'
  },
  :params => {},
  :log => "./test.log"
}

WIDGETS_REST_CLIENT = Resourceful::Agent::RestClient.new(:host => RESOURCE_CONFIG[:host])

