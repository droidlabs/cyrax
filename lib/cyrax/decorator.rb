require 'active_model'
class Cyrax::Decorator < Cyrax::Wrapper
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

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

  def respond_to?(method_sym, include_private = false)
    super || resource.respond_to?(method_sym, include_private)
  end

  class << self
    alias_method :decorate, :new

    def decorate_collection(resource)
      Cyrax::Presenters::DecoratedCollection.decorate(resource, decorator: self)
    end
  end
end
