module Cyrax::Extensions
  module HasDecorator
    extend ActiveSupport::Concern

    included do
      class_attribute :decorator_class_name
    end

    module ClassMethods
      def decorator(name)
        self.decorator_class_name = name.to_s
      end
    end

    def decorated_collection
      decorable? ? build_decorated_collection : wrapped_collection
    end

    private

    def decorable?
      !self.class.decorator_class_name.nil?
    end

    def decorator_class
      self.class.decorator_class_name.to_s.classify.constantize
    end

    def wrapped_collection
      collection = build_collection

      if collection.kind_of?(Array)
        return collection
      elsif collection.respond_to?(:all)
        return collection.all
      else
        return Array.wrap(collection)
      end
    end

    def build_decorated_collection
      wrapped_collection.map{|i| decorator_class.new(i)}
    end
  end
end
