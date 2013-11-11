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

    def default_attributes
      scope.default_attributes
    end

    def attributes(*attrs)
      scope.attributes(*attrs)
    end

    def attribute(attribute, options = {}, &block)
      scope.attribute(attribute, options, &block)
    end
  end
end