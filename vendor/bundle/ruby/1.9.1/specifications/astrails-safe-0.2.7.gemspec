# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "astrails-safe"
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Astrails Ltd."]
  s.date = "2010-01-21"
  s.description = "Astrails-Safe is a simple tool to backup databases (MySQL and PostgreSQL), Subversion repositories (with svndump) and just files.\nBackups can be stored locally or remotely and can be enctypted.\nRemote storage is supported on Amazon S3, Rackspace Cloud Files, or just plain SFTP.\n"
  s.email = "we@astrails.com"
  s.executables = ["astrails-safe"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = ["bin/astrails-safe", "LICENSE", "README.markdown"]
  s.homepage = "http://blog.astrails.com/astrails-safe"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Backup filesystem and databases (MySQL and PostgreSQL) locally or to a remote server/service (with encryption)"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<aws-s3>, [">= 0"])
      s.add_runtime_dependency(%q<cloudfiles>, [">= 0"])
      s.add_runtime_dependency(%q<net-sftp>, [">= 0"])
    else
      s.add_dependency(%q<aws-s3>, [">= 0"])
      s.add_dependency(%q<cloudfiles>, [">= 0"])
      s.add_dependency(%q<net-sftp>, [">= 0"])
    end
  else
    s.add_dependency(%q<aws-s3>, [">= 0"])
    s.add_dependency(%q<cloudfiles>, [">= 0"])
    s.add_dependency(%q<net-sftp>, [">= 0"])
  end
end
