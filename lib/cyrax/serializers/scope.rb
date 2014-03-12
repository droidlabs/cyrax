module Cyrax::Serializers
  class Scope
    def initialize(&block)
      @attrs = {}
      @dynamic_attrs = {}
      @relation_attrs = {}
      @namespace_attrs = {}
      @assigned_attrs = {}
      @default_attributes = false
      instance_eval(&block) if block_given?
    end

    def namespace(name, &block)
      @namespace_attrs[name] = self.class.new(&block)
    end

    def assigned(name, &block)
      @assigned_attrs[name] = self.class.new(&block)
    end

    def relation(attribute, &block)
      if block_given?
        @relation_attrs[attribute] = self.class.new(&block)
      else
        @attrs[attribute] = attribute
      end
    end
    alias_method :has_many, :relation
    alias_method :has_one, :relation

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
      if resource.respond_to?(:to_a)
        resource.to_a.map{ |r| serialize_one(r, options) }
      else
        serialize_one(resource, options)
      end
    end

    def serialize_one(resource, options = {})
      result = {}
      if @default_attributes
        result = resource.attributes rescue {}
      end
      @dynamic_attrs.map do |attribute, block|
        result[attribute] = options[:serializer].instance_exec(resource, &block)
      end
      @relation_attrs.map do |attribute, scope|
        value = resource.send(attribute)
        result[attribute] = scope.serialize(value)
      end
      @assigned_attrs.map do |attribute, scope|
        value = options[:assignments][attribute]
        result[attribute] = scope.serialize(value)
      end
      @namespace_attrs.map do |attribute, scope|
        result[attribute] = scope.serialize(resource)
      end
      @attrs.map do |attribute, options|
        result[attribute] = resource.send(attribute)
      end
      result
    end
  end
end