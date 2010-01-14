# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hoptoad-ribbit}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glen Mailer"]
  s.date = %q{2010-01-14}
  s.description = %q{
      Provides a Module to handle sending notifications to hoptoad.

      Currently includes a Merb adapter, but the intention is to add more later.
    }
  s.email = %q{glenjamin@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "hoptoad-ribbit.gemspec",
     "lib/ribbit.rb",
     "lib/ribbit/adapters.rb",
     "lib/ribbit/adapters/adapter.rb",
     "lib/ribbit/adapters/merb.rb",
     "lib/ribbit/adapters/none.rb",
     "lib/ribbit/backtrace.rb",
     "lib/ribbit/configuration.rb",
     "lib/ribbit/notice.rb",
     "lib/ribbit/sender.rb",
     "spec/ribbit_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/glenjamin/hoptoad-notifier}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Generic Hoptoad Notifications and an adapter for merb}
  s.test_files = [
    "spec/ribbit_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 2.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<builder>, [">= 2.0.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<builder>, [">= 2.0.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

