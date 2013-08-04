class Cyrax::Decorator
  attr_accessor :resource

  def initialize(resource)
    @resource = resource
  end

  def to_model
    resource
  end

  def method_missing(method, *args, &block)
    return super unless resource.respond_to?(method)

    resource.send(method, *args, &block)
  end
end
