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

  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency "active_model_serializers"
  spec.add_dependency "activemodel-serializers-xml"
  spec.add_dependency "has_active_logger"
  spec.add_dependency "multi_json"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec", '~> 2.99.0'
end
