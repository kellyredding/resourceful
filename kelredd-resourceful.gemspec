# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{kelredd-resourceful}
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Redding"]
  s.date = %q{2010-03-16}
  s.email = %q{kelly@kelredd.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/resourceful", "lib/resourceful/agent", "lib/resourceful/agent/base.rb", "lib/resourceful/agent/mechanize.rb", "lib/resourceful/agent/rest_client.rb", "lib/resourceful/agent.rb", "lib/resourceful/exceptions.rb", "lib/resourceful/extensions.rb", "lib/resourceful/model", "lib/resourceful/model/activerecord_associations.rb", "lib/resourceful/model/attribute_types.rb", "lib/resourceful/model/base.rb", "lib/resourceful/model/eager_load.rb", "lib/resourceful/model/embedded_associations.rb", "lib/resourceful/model/external_associations.rb", "lib/resourceful/model/findable.rb", "lib/resourceful/model/json.rb", "lib/resourceful/model/xml.rb", "lib/resourceful/model.rb", "lib/resourceful/resource", "lib/resourceful/resource/cache.rb", "lib/resourceful/resource/format.rb", "lib/resourceful/resource.rb", "lib/resourceful/shoulda", "lib/resourceful/shoulda/test_unit.rb", "lib/resourceful/shoulda.rb", "lib/resourceful/version.rb", "lib/resourceful.rb"]
  s.homepage = %q{}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A ruby gem to abstract web resource handling.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
      s.add_runtime_dependency(%q<log4r>, [">= 0"])
      s.add_runtime_dependency(%q<kelredd-useful>, [">= 0.2.5"])
      s.add_development_dependency(%q<shoulda>, [">= 2.10.2"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<mechanize>, [">= 0"])
      s.add_dependency(%q<log4r>, [">= 0"])
      s.add_dependency(%q<kelredd-useful>, [">= 0.2.5"])
      s.add_dependency(%q<shoulda>, [">= 2.10.2"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<mechanize>, [">= 0"])
    s.add_dependency(%q<log4r>, [">= 0"])
    s.add_dependency(%q<kelredd-useful>, [">= 0.2.5"])
    s.add_dependency(%q<shoulda>, [">= 2.10.2"])
  end
end
