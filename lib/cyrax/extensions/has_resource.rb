require 'active_support'
module Cyrax::Extensions
  module HasResource
    extend ActiveSupport::Concern

    included do
      class_attribute :resource_name
      class_attribute :resource_class_name
    end

    def resource_class
      if self.class.resource_class_name
        self.class.resource_class_name.constantize
      else
        resource_name.classify.constantize
      end
    end

    def resource_scope
      resource_class
    end

    def collection_name
      resource_name.pluralize
    end

    def resource_attributes
      filter_attributes(dirty_resource_attributes)
    end

    def build_resource(id, attributes = {})
      if id.present?
        resource = find_resource(id)
        resource.attributes = attributes
        resource
      else
        resource_scope.new(default_resource_attributes.merge(attributes))
      end
    end

    def build_collection
      resource_scope
    end

    def find_resource(id)
      resource_scope.find(id)
    end

    module ClassMethods
      def resource(name, options = {})
        self.resource_name = name.to_s
        self.resource_class_name = options[:class_name]
      end
    end

    private
      def dirty_resource_attributes
        params[resource_name] || {}
      end

      def default_resource_attributes
        {}
      end

      def filter_attributes(attributes)
        attributes
      end
  end
end
