# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'cyrax/version'

Gem::Specification.new do |spec|
  spec.name          = "cyrax"
  spec.version       = Cyrax::VERSION
  spec.authors       = ["Droidlabs"]
  spec.description   = "Small library for adding service layer to Rails projects"
  spec.summary       = "Small library for adding service layer to Rails projects"
  spec.license       = "MIT"

  spec.files = Dir["lib/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "active_model_serializers"
  spec.add_dependency "activemodel-serializers-xml"
  spec.add_dependency "activesupport", '~> 6.0'
  spec.add_dependency "activemodel", '~> 6.0'
  spec.add_dependency "has_active_logger"
  spec.add_dependency "multi_json"

  spec.add_development_dependency "sqlite3", '~> 1.5'
  spec.add_development_dependency "rspec", '~> 3.12'
  spec.add_development_dependency "rspec-its", '~> 1.3'
end
