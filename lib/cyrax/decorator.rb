class Cyrax::Decorator
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
end
