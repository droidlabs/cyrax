require 'active_support/core_ext/object'
require 'active_support/core_ext/class'
require "cyrax/version"
require "cyrax/extensions/has_resource.rb"
require "cyrax/extensions/has_response.rb"
require "cyrax/extensions/has_service.rb"
require "cyrax/extensions/has_decorator.rb"
require "cyrax/extensions/has_serializer.rb"
require "cyrax/presenters/base_collection.rb"
require "cyrax/presenters/decorated_collection.rb"
require "cyrax/serializers/scope.rb"
require "cyrax/helpers/controller.rb"
require "cyrax/base.rb"
require "cyrax/resource.rb"
require "cyrax/wrapper.rb"
require "cyrax/presenter.rb"
require "cyrax/response.rb"
require "cyrax/decorator.rb"
require "cyrax/serializer.rb"

module Cyrax
  @@strong_parameters = true

  def self.strong_parameters
    @@strong_parameters
  end

  def self.strong_parameters=(value)
    @@strong_parameters = value
  end
end
