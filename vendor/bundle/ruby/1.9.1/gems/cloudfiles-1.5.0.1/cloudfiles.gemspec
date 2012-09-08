require File.expand_path('../lib/cloudfiles/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{cloudfiles}
  s.version = CloudFiles::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["H. Wade Minter", "Rackspace Hosting"]
  s.description = %q{A Ruby version of the Rackspace Cloud Files API.}
  s.email = %q{minter@lunenburg.org}
  s.extra_rdoc_files = [
    "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "CONTRIBUTORS",
     "COPYING",
     "Gemfile",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "cloudfiles.gemspec",
     "lib/cloudfiles.rb",
     "lib/client.rb",
     "lib/cloudfiles/authentication.rb",
     "lib/cloudfiles/connection.rb",
     "lib/cloudfiles/container.rb",
     "lib/cloudfiles/exception.rb",
     "lib/cloudfiles/storage_object.rb",
     "lib/cloudfiles/version.rb",
     "test/cf-testunit.rb",
     "test/cloudfiles_authentication_test.rb",
     "test/cloudfiles_connection_test.rb",
     "test/cloudfiles_container_test.rb",
     "test/cloudfiles_storage_object_test.rb",
     "test/cloudfiles_client_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://www.rackspacecloud.com/cloud_hosting_products/files}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0.1}
  s.summary = %q{A Ruby API into Rackspace Cloud Files}
  s.test_files = [
    "test/cf-testunit.rb",
     "test/cloudfiles_authentication_test.rb",
     "test/cloudfiles_connection_test.rb",
     "test/cloudfiles_container_test.rb",
     "test/cloudfiles_storage_object_test.rb",
     "test/cloudfiles_client_test.rb",
     "test/test_helper.rb"
  ]

  s.add_dependency('json')

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
    else
      s.add_dependency(%q<mocha>, ["~> 0.9.8"])
    end
  else
    s.add_dependency(%q<mocha>, ["~> 0.9.8"])
  end
end

