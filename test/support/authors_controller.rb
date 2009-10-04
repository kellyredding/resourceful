require 'rubygems'
require 'fakeweb'

AUTHORS_ALL_JSON = %{
[{"name": "Joe", "id": 1, "address": {"street": "1234 Elm", "city": "A City", "state": "A State"}}]
}

AUTHORS_1_JSON = %{
{"name": "Joe", "id": 1, "address": {"street": "1234 Elm", "city": "A City", "state": "A State"}}
}

FakeWeb.register_uri(:get, "#{BLOG_HOST}/authors.json", :body => AUTHORS_ALL_JSON)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/authors/1.json", :body => AUTHORS_1_JSON)
