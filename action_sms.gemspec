# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "action_sms/version"

Gem::Specification.new do |s|
  s.name        = "action_sms"
  s.version     = ActionSms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Wilkie"]
  s.email       = ["dwilkie@gmail.com"]
  s.homepage    = "http://github.com/dwilkie/action_sms"
  s.summary     = %q{Effortlessly switch between SMS Gateways}
  s.description = %q{Switch between SMS Gateways at a whim without modifying your application code or tests}

  s.rubyforge_project = "action_sms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "tropo_message", ">=0.1.0"
  s.add_runtime_dependency "rack"
end

