class Cyrax::Serializer
  attr_accessor :object
  def initialize(object)
    @object = object
  end

  def serialize
    self.class.scope.serialize(object)
  end

  class << self
    def scope
      @scope ||= Cyrax::Serializers::Scope.new()
    end

    def namespace(name, &block)
      scope.namespace(name, &block)
    end

    def attributes(*attrs)
      scope.attributes(*attrs)
    end

    def attribute(attribute, options = {})
      scope.attribute(attribute, options)
    end
  end
end