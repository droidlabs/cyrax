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

    def assigned(name, &block)
      scope.assigned(name, &block)
    end

    def relation(name, &block)
      scope.relation(name, &block)
    end
    alias_method :has_many, :relation
    alias_method :has_one, :relation

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