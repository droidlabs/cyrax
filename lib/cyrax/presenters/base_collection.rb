module Cyrax::Presenters
  class BaseCollection
    attr_reader :collection
    
    def initialize(collection, options = {})
      @collection = collection
    end

    array_methods = Array.instance_methods - Object.instance_methods
    delegate *array_methods, to: :presented_collection

    def presented_collection
      if collection.is_a?(ActiveRecord::Relation)
        collection.to_a
      elsif collection.respond_to?(:all)
        collection.all
      else
        Array.wrap collection
      end
    end

    def as_json
      if options[:serializer]
        options[:serializer].new(presented_collection).as_json
      else
        presented_collection.as_json
      end
    end

    def method_missing(method, *args, &block)
      return super unless collection.respond_to?(method)
      collection.send(method, *args, &block)
    end
  end
end