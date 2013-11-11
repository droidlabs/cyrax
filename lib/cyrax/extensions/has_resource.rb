require 'active_support'
module Cyrax::Extensions
  module HasResource
    extend ActiveSupport::Concern

    included do
      class_attribute :resource_name
      class_attribute :resource_class_name
      class_attribute :collection_name
    end

    # Returns the resource class as a constant - e.g. Product
    def resource_class
      if self.resource_class_name
        self.resource_class_name.constantize
      else
        resource_name.classify.constantize
      end
    end

    # Returns the resource class - e.g. Product
    # You can override this in your resource by defining the method and returning your own scope
    #
    # @example Overriding resource_scope
    #   class Products::UserResource < Products::BaseResource
    #     def resource_scope
    #       accessor.products
    #     end
    #   end
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

      # Class method for setting all the attributes that you want to access in the resource
      #
      # @example
      #   accessible_attributes :description, :model, :price_in_cents, :vendor
      #
      # @param attrs [Array(Symbol)] Symbols of the attributes
      def accessible_attributes(*attrs)
        if attrs.blank?
          @accessible_attributes || []
        else
          @accessible_attributes ||= []
          @accessible_attributes += attrs
        end
      end

      # Class method for setting the resource that you want to access
      #
      # @example
      #   resource :product
      #
      # @param name [Symbol] The name of the resource
      # @param options Hash [Hash] Options
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
