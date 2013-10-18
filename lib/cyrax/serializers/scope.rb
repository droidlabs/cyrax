module Cyrax::Serializers
  class Scope
    def initialize(&block)
      @attrs = {}
      instance_eval(&block) if block_given?
    end

    def namespace(name, &block)
      @attrs[name] = self.class.new(&block)
    end

    def attributes(*attrs)
      attrs.map do |attribute|
        attribute(attribute)
      end
    end

    def attribute(attribute, options = {})
      @attrs ||= {}
      @attrs[attribute] ||= attribute
    end

    def serialize(object)
      result = {}
      @attrs.map do |attribute, options|
        value = object.send(attribute)
        if options.is_a?(Cyrax::Serializers::Scope)
          value = options.serialize(value)
        end
        result[attribute] = value
      end
      result
    end
  end
end