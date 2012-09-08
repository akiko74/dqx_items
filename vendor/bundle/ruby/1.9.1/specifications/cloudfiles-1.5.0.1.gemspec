# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cloudfiles"
  s.version = "1.5.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["H. Wade Minter", "Rackspace Hosting"]
  s.date = "2011-12-06"
  s.description = "A Ruby version of the Rackspace Cloud Files API."
  s.email = "minter@lunenburg.org"
  s.extra_rdoc_files = ["README.rdoc", "TODO"]
  s.files = ["README.rdoc", "TODO"]
  s.homepage = "http://www.rackspacecloud.com/cloud_hosting_products/files"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A Ruby API into Rackspace Cloud Files"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.8"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.8"])
  end
end
