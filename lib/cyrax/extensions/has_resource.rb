require 'active_support'
module Cyrax::Extensions
  module HasResource
    extend ActiveSupport::Concern

    included do
      class_attribute :_resource_name
      class_attribute :_collection_name
      class_attribute :_resource_class
    end

    def resource_name
      self.class._resource_name
    end

    def collection_name
      self.class._collection_name
    end

    # Returns the resource class as a constant - e.g. Product
    def resource_class
      self.class._resource_class || resource_name.classify.constantize
    end

    def resource_attributes
      filter_attributes(dirty_resource_attributes)
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
        if options[:class_name].present?
          ActiveSupport::Deprecation.warn "sending :class_name in #resource method is deprecated. send :class instead"
          options[:class] = options[:class_name].to_s.constantize
        end
        self._resource_name = name.to_s
        self._resource_class = options[:class]
        self._collection_name = name.to_s.pluralize
      end
    end

    private
      def response_name
        resource_name
      end

      def dirty_resource_attributes
        if Cyrax.strong_parameters
          params.require(resource_name)
        else
          params[resource_name] || {}
        end
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
