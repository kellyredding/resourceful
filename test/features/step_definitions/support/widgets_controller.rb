require 'rubygems'
require 'fakeweb'

require File.join(File.dirname(__FILE__), 'widget.rb')

WIDGETS_HOST = "http://widgets.local"
WIDGETS_ALL_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <widgets type="array">
    <widget>
      <name>One</name>
      <id type="integer">1</id>
    </widget>
    <widget>
      <name>Two</name>
      <id type="integer">2</id>
    </widget>
    <widget>
      <name>Three</name>
      <id type="integer">3</id>
    </widget>
    <widget>
      <name>Four</name>
      <id type="integer">4</id>
    </widget>
    <widget>
      <name>Five</name>
      <id type="integer">5</id>
    </widget>
    <widget>
      <name>TrueClass</name>
      <id type="boolean">true</id>
    </widget>
    <widget>
      <name>FalseClass</name>
      <id type="boolean">false</id>
    </widget>
    <widget>
      <name>Time Now</name>
      <id type="datetime">2009-08-11T09:38:34-05:00</id>
    </widget>
  </widgets>
}
WIDGETS_ALL_JSON = %{
[{"name": "One", "id": 1}, {"name": "Two", "id": 2}, {"name": "Three", "id": 3}, {"name": "Four", "id": 4}, {"name": "Five", "id": 5}, {"name": "TrueClass", "id": true}, {"name": "FalseClass", "id": false}, {"name": "Time Now", "id": "2009/08/11 09:39:46 -0500"}]
}
WIDGETS_1_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <widget>
    <name>One</name>
    <id type="integer">1</id>
  </widget>
}
WIDGETS_EDIT_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <widget>
    <name>Foo</name>
    <id type="integer">1</id>
  </widget>
}
WIDGETS_1_JSON = %{
{"name": "One", "id": 1}
}
WIDGETS_EDIT_JSON = %{
{"name": "Foo", "id": 1}
}
FakeWeb.register_uri(:get, "#{WIDGETS_HOST}/widgets.xml", :body => WIDGETS_ALL_XML)
FakeWeb.register_uri(:get, "#{WIDGETS_HOST}/widgets.json", :body => WIDGETS_ALL_JSON)
FakeWeb.register_uri(:post, "#{WIDGETS_HOST}/widgets.xml", :body => WIDGETS_EDIT_XML)
FakeWeb.register_uri(:post, "#{WIDGETS_HOST}/widgets.json", :body => WIDGETS_EDIT_JSON)
FakeWeb.register_uri(:put, "#{WIDGETS_HOST}/widgets/1.xml", :body => WIDGETS_EDIT_XML)
FakeWeb.register_uri(:put, "#{WIDGETS_HOST}/widgets/1.json", :body => WIDGETS_EDIT_JSON)
FakeWeb.register_uri(:delete, "#{WIDGETS_HOST}/widgets/1.xml", :body => WIDGETS_1_XML)
FakeWeb.register_uri(:delete, "#{WIDGETS_HOST}/widgets/1.json", :body => WIDGETS_1_JSON)
FakeWeb.register_uri(:get, "#{WIDGETS_HOST}/widgets/1.xml", :body => WIDGETS_1_XML)
FakeWeb.register_uri(:get, "#{WIDGETS_HOST}/widgets/1.json", :body => WIDGETS_1_JSON)
FakeWeb.register_uri(:get, "#{WIDGETS_HOST}/unknown.xml", :status => ["404", "Not Found"], :body => "")

