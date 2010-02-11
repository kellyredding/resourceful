# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'active_support'
require 'test/unit'
require 'shoulda'

# Add test and lib paths to the $LOAD_PATH
[ File.dirname(__FILE__),
  File.join(File.dirname(__FILE__), '..', 'lib')
].each do |path|
  full_path = File.expand_path(path)
  $LOAD_PATH.unshift(full_path) unless $LOAD_PATH.include?(full_path)
end

require 'resourceful'
require 'resourceful/shoulda'

# Setup fakeweb objects for testing purposes

WIDGETS_HOST = "http://widgets.local"
BLOG_HOST = "http://blog-example.local"
module Blog; end

Dir[File.join(File.dirname(__FILE__), "fixtures" ,"*.rb")].each do |file|
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

