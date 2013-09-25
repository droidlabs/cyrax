require 'active_support'
module Cyrax::Extensions
  module HasResource
    extend ActiveSupport::Concern

    included do
      register_extension :has_resource
      class_attribute :resource_name
      class_attribute :resource_class_name
      class_attribute :collection_name
    end

    def resource_class
      if self.resource_class_name
        self.resource_class_name.constantize
      else
        resource_name.classify.constantize
      end
    end

    def resource_scope
      resource_class
    end

    def resource_attributes
      filter_attributes(dirty_resource_attributes)
    end

    def response_name
      resource_name
    end

    module ClassMethods
      def accessible_attributes(*attrs)
        if attrs.blank?
          @accessible_attributes || []
        else
          @accessible_attributes ||= []
          @accessible_attributes += attrs
        end
      end

      def resource(name, options = {})
        self.resource_name = name.to_s
        self.resource_class_name = options[:class_name]
        self.collection_name = name.to_s.pluralize
      end
    end

    private
      def dirty_resource_attributes
        if Cyrax.strong_parameters
          params.require(resource_name)
        else
          params[resource_name] || {}
        end
      end

      def default_resource_attributes
        {}
      end

      def filter_attributes(attributes)
        if Cyrax.strong_parameters
          attributes.permit(self.class.accessible_attributes)
        elsif self.class.accessible_attributes.blank?
          attributes
        else
          attributes.slice(*self.class.accessible_attributes)
        end
      end
  end
end
