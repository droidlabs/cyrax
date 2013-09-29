require 'active_model'
class Cyrax::Decorator
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  attr_accessor :resource

  def initialize(resource)
    @resource = resource
  end

  def to_model
    resource
  end

  def to_param
    resource.to_param
  end

  def to_partial_path
    resource.to_partial_path
  end

  def method_missing(method, *args, &block)
    return super unless resource.respond_to?(method)
    resource.send(method, *args, &block)
  end

  class << self
    alias_method :decorate, :new

    def decorate_collection(resource)
      Cyrax::DecoratedCollectionPresenter.decorate(resource, decorator_class: self)
    end
  end
end
