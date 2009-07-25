# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{resourceful}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Redding"]
  s.date = %q{2009-07-24}
  s.email = %q{kelly@kelredd.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "features/config_resource.feature", "features/get_resource.feature", "features/resource_models.feature", "features/step_definitions", "features/step_definitions/resource_config_steps.rb", "features/step_definitions/resource_get_steps.rb", "features/step_definitions/resource_models_steps.rb", "features/step_definitions/support", "features/step_definitions/support/env.rb", "features/step_definitions/support/helpers.rb", "features/step_definitions/support/models.rb", "features/step_definitions/support/resources.rb", "lib/resourceful", "lib/resourceful/exceptions.rb", "lib/resourceful/extensions.rb", "lib/resourceful/model", "lib/resourceful/model/base.rb", "lib/resourceful/model/json.rb", "lib/resourceful/model/xml.rb", "lib/resourceful/model.rb", "lib/resourceful/resource", "lib/resourceful/resource/base.rb", "lib/resourceful/resource/cache.rb", "lib/resourceful/resource/format.rb", "lib/resourceful/resource.rb", "lib/resourceful/version.rb", "lib/resourceful.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A ruby gem to abstract web resource handling.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<log4r>, [">= 0"])
      s.add_runtime_dependency(%q<kelredd-useful>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<log4r>, [">= 0"])
      s.add_dependency(%q<kelredd-useful>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<log4r>, [">= 0"])
    s.add_dependency(%q<kelredd-useful>, [">= 0"])
  end
end