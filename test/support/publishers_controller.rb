require 'rubygems'
require 'fakeweb'

PUBLISHERS_ALL_JSON = %{
[{"id": 1, "name": "Jasper"}, {"id": 2, "name": "James"}, {"id": 3, "name": "John"}, {"id": 4, "name": "Jack"}, {"id": 5, "name": "Jerry"}]
}

PUBLISHERS_1_JSON = %{
{"name": "Jasper", "id": 1}
}

FakeWeb.register_uri(:get, "#{BLOG_HOST}/publishers.json", :body => PUBLISHERS_ALL_JSON)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/publishers.json?id=1,2,3,4,5", :body => PUBLISHERS_ALL_JSON)
FakeWeb.register_uri(:get, "#{BLOG_HOST}/publishers/1.json", :body => PUBLISHERS_1_JSON)
