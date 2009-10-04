require 'rubygems'
require 'fakeweb'

POSTS_ALL_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <posts type="array">
    <post>
      <name>One</name>
      <id type="integer">1</id>
      <author-id type="integer">1</author-id>
      <comments type="array">
        <comment>
          <user-name>foo</user-name>
          <text type="boring" key="integer-123">Blah Blah</text>
          <count type="integer">362</count>
          <average type="float">141.72345</average>
          <cost>$9.99</cost>
          <on>10/25/2009</on>
          <at>10/25/2009 13:45:27</at>
          <valid type="boolean">true</valid>
          <line class="one">line 1</line>
          <line class="three">line 3</line>
        </comment>
        <comment>
          <user-name>bar</user-name>
          <text type="super" key="integer-456">That. Was. Awesome.</text>
          <line class="one">line 1</line>
          <line class="two">line 2</line>
        </comment>
      </comments>
    </post>
    <post>
      <name>Two</name>
      <id type="integer">2</id>
      <author-id type="integer">1</author-id>
      <comments type="array">
      </comments>
    </post>
  </posts>
}

POSTS_1_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <post>
    <name>One</name>
    <id type="integer">1</id>
    <author-id type="integer">1</author-id>
    <comments type="array">
      <comment>
        <user-name>poo</user-name>
        <text>Blah Blah</text>
      </comment>
      <comment>
        <user-name>bar</user-name>
        <text>That Sucked</text>
      </comment>
    </comments>
  </post>
}

POSTS_2_XML = %{<?xml version="1.0" encoding="UTF-8"?>
  <post>
    <name>Two</name>
    <id type="integer">2</id>
    <author-id type="integer">1</author-id>
    <comments type="array">
    </comments>
  </post>
}

FakeWeb.register_uri(:get, "#{BLOG_HOST}/posts.xml", :body => POSTS_ALL_XML)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/posts.xml?author_id=1", :body => POSTS_ALL_XML)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/posts/1.xml", :body => POSTS_1_XML)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/posts/2.xml", :body => POSTS_2_XML)
