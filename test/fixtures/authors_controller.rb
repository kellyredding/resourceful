require 'rubygems'
require 'fakeweb'

AUTHORS_ALL_JSON = %{
[{"name": "Joe", "id": 1, "parent_type": "Publisher", "parent_id": 1, "address": {"street": "1234 Elm", "city": "A City", "state": "A State"}}, {"name": "Bob", "id": 2, "parent_type": "Publisher", "parent_id": 2}, {"name": "Karl", "id": 3, "parent_type": "Publisher", "parent_id": 3}, {"name": "Steve", "id": 4, "parent_type": "Publisher", "parent_id": 4}, {"name": "Horacio", "id": 5, "parent_type": "Publisher", "parent_id": 5}]
}

AUTHORS_1_JSON = %{
{"name": "Joe", "id": 1, "parent_type": "Publisher", "parent_id": 1, "address": {"street": "1234 Elm", "city": "A City", "state": "A State"}}
}
AUTHORS_PUBLISHER_1_JSON = %{
[{"name": "Joe", "id": 1, "parent_type": "Publisher", "parent_id": 1, "address": {"street": "1234 Elm", "city": "A City", "state": "A State"}}]
}

FakeWeb.register_uri(:get, "#{BLOG_HOST}/authors.json", :body => AUTHORS_ALL_JSON)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/authors/1.json", :body => AUTHORS_1_JSON)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/authors.json?publisher_id=1", :body => AUTHORS_PUBLISHER_1_JSON)
