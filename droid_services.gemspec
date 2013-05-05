# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'droid_services/version'

Gem::Specification.new do |spec|
  spec.name          = "droid_services"
  spec.version       = DroidServices::VERSION
  spec.authors       = ["Droidlabs"]
  spec.description   = "Droid Services"
  spec.summary       = "Droid Services"
  spec.license       = "MIT"

  spec.files = Dir["lib/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "activesupport"
  spec.add_dependency "has_active_logger"

  spec.add_development_dependency "rspec"
end
