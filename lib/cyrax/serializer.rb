class Cyrax::Serializer < Cyrax::Wrapper
  def serialize
    options[:serializer] = self
    self.class.scope.serialize(resource, options)
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