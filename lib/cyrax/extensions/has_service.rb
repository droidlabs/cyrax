module Cyrax::Extensions
  module HasService
    extend ActiveSupport::Concern

    # Builds and returns a collection response for Rails
    # @return [Cyrax::Response] Response for Rails controller
    def collection
      respond_with build_collection, name: collection_name, present: :collection
    end
    # Overrides collection with read_all
    alias_method :read_all, :collection
    alias_method :read_all!, :collection

    def build
      respond_with build_resource(nil)
    end
    alias_method :build!, :build

    def create(custom_attributes = nil, &block)
      resource = build_resource(nil, custom_attributes||resource_attributes)
      transaction do
        invoke_callback(:before_create, resource)
        invoke_callback(:before_save, resource)
        if save_resource(resource)
          invoke_callback(:after_create, resource)
          invoke_callback(:after_save, resource)
          set_message("#{resource_name.titleize} successfully created")
          block.call(resource) if block_given?
        else
          add_errors_from(resource)
        end
      end
      respond_with(resource)
    end
    alias_method :create!, :create

    def read
      respond_with find_resource(params[:id])
    end
    alias_method :read!, :read
    alias_method :edit, :read
    alias_method :edit!, :read


    def update(custom_attributes = nil, &block)
      resource = build_resource(params[:id], custom_attributes||resource_attributes)
      transaction do
        invoke_callback(:before_update, resource)
        invoke_callback(:before_save, resource)
        if save_resource(resource)
          invoke_callback(:after_update, resource)
          invoke_callback(:after_save, resource)
          set_message("#{resource_name.titleize} successfully updated")
          block.call(resource) if block_given?
        else
          add_errors_from(resource)
        end
      end
      respond_with(resource)
    end
    alias_method :update!, :update

    def destroy(&block)
      resource = find_resource(params[:id])
      transaction do
        invoke_callback(:before_destroy, resource)
        delete_resource(resource)
        invoke_callback(:after_destroy, resource)
        block.call(resource) if block_given?
      end
      respond_with(resource)
    end
    alias_method :destroy!, :destroy

    def find_resource(id)
      resource_scope.find(id)
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

    def save_resource(resource)
      resource.save
    end

    def delete_resource(resource)
      resource.destroy
    end

    # Returns a collection of the resource we are calling.
    #
    # If you want your resource to return something interesting, you should override the resource_scope method. Otherwise by default it will return the constantized model name.
    #
    # @return [type] The collection
    # @todo Refactor this? It just returns the constantized class. Confusing as all hell.
    def build_collection
      resource_scope
    end

    def transaction(&block)
      if defined?(ActiveRecord::Base)
        ActiveRecord::Base.transaction do
          block.call
        end
      else
        block.call
      end
    end
  end
end
