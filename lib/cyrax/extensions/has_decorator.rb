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
      if decorable?
        build_decorated_collection
      else
        build_collection
      end
    end

    private

    def decorable?
      !self.class.decorator_class_name.nil?
    end

    def decorator_class
      self.class.decorator_class_name.to_s.classify.constantize
    end

    def prepare_collection_for_decorate
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
      prepare_collection_for_decorate.map{|i| decorator_class.new(i)}
    end
  end
end
