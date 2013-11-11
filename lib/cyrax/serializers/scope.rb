module Cyrax::Serializers
  class Scope
    def initialize(&block)
      @attrs = {}
      @dynamic_attrs = {}
      @default_attributes = false
      instance_eval(&block) if block_given?
    end

    def namespace(name, &block)
      @attrs[name] = self.class.new(&block)
    end

    def default_attributes
      @default_attributes = true
    end

    def attributes(*attrs)
      attrs.map do |attribute|
        attribute(attribute)
      end
    end

    def attribute(attribute, options = {}, &block)
      if block_given?
        @dynamic_attrs[attribute] = block
      else
        @attrs[attribute] = attribute
      end
    end

    def serialize(resource, options = {})
      if resource.is_a?(Array)
        resource.map{ |r| serialize_one(r, options) }
      else
        serialize_one(resource, options)
      end
    end

    def serialize_one(resource, options = {})
      result = {}
      if @default_attributes && resource.respond_to?(:attributes)
        result = resource.attributes
      end
      @attrs.map do |attribute, options|
        value = resource.send(attribute)
        if options.is_a?(Cyrax::Serializers::Scope)
          value = options.serialize(value)
        end
        result[attribute] = value
      end
      @dynamic_attrs.map do |attribute, block|
        result[attribute] = options[:serializer].instance_exec(resource, &block)
      end
      result
    end
  end
end