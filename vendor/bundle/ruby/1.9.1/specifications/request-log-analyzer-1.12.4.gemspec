# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "request-log-analyzer"
  s.version = "1.12.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Willem van Bergen", "Bart ten Brinke"]
  s.date = "2012-08-05"
  s.description = "    Request log analyzer's purpose is to find out how your web application is being used, how it performs and to\n    focus your optimization efforts. This tool will parse all requests in the application's log file and aggregate the \n    information. Once it is finished parsing the log file(s), it will show the requests that take op most server time \n    using various metrics. It can also insert all parsed request information into a database so you can roll your own\n    analysis. It supports Rails-, Merb- and Rack-based applications logs, Apache and Amazon S3 access logs and MySQL \n    slow query logs out of the box, but file formats of other applications can easily be supported by supplying an \n    easy to write log file format definition.\n"
  s.email = ["willem@railsdoctors.com", "bart@railsdoctors.com"]
  s.executables = ["request-log-analyzer"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["bin/request-log-analyzer", "README.rdoc"]
  s.homepage = "http://railsdoctors.com"
  s.rdoc_options = ["--title", "request-log-analyzer", "--main", "README.rdoc", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.requirements = ["To use the database inserter, ActiveRecord and an appropriate database adapter are required."]
  s.rubyforge_project = "r-l-a"
  s.rubygems_version = "1.8.24"
  s.summary = "A command line tool to analyze request logs for Apache, Rails, Merb, MySQL and other web application servers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
