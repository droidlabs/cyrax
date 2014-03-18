class Cyrax::Serializer < Cyrax::Wrapper
  def serialize
    options[:serializer] = self
    
    if block = self.class.total_count_block
      serialize_wrapped(options, &block)
    else
      serialize_simple(options)
    end
  end

  def serialize_simple(options = {})
    self.class.scope.serialize(resource, options)
  end

  def serialize_wrapped(options = {}, &counter_block)
    total_count = self.instance_eval(&counter_block)
    data = self.class.scope.serialize(resource, options)
    {total_count: total_count, data: data}
  end

  class << self
    def scope
      @scope ||= Cyrax::Serializers::Scope.new()
    end

    def total_count(&block)
      @total_count_block = block
    end

    def total_count_block
      @total_count_block
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