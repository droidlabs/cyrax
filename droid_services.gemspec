# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'droid_services/version'

Gem::Specification.new do |spec|
  spec.name          = "droid_services"
  spec.version       = DroidServices::VERSION
  spec.authors       = ["Droidlabs"]
  spec.description   = "Droid DroidServices"
  spec.summary       = "Droid DroidServices"
  spec.license       = "MIT"

  spec.files = Dir["lib/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "yell"
  spec.add_dependency "json"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "rspec"
end
