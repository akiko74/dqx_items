# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{net-http-spy}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Sadler"]
  s.date = %q{2009-12-05}
  s.description = %q{Ever wondered what HTTP requests the Ruby gem you are using to connect to a third party API is making? Use HTTP Spy to see what is going on behind the scenes.}
  s.email = %q{martin@beyondthetype.com}
  s.files = [
    "Rakefile",
     "VERSION",
     "examples/fogbugz.rb",
     "examples/google.rb",
     "examples/twitter-calltrace.rb",
     "examples/twitter-customlog.rb",
     "examples/twitter-simple.rb",
     "examples/twitter-verbose.rb",
     "examples/twitter-withbody.rb",
     "lib/net-http-spy.rb",
     "net-http-spy.gemspec",
     "readme.markdown",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/spy_spec.rb"
  ]
  s.homepage = %q{http://github.com/martinbtt/net-http-spy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ever wondered what HTTP requests the Ruby gem you are using to connect to a third party API is making? Use HTTP Spy to see what is going on behind the scenes.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/spy_spec.rb",
     "examples/fogbugz.rb",
     "examples/google.rb",
     "examples/twitter-calltrace.rb",
     "examples/twitter-customlog.rb",
     "examples/twitter-simple.rb",
     "examples/twitter-verbose.rb",
     "examples/twitter-withbody.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
