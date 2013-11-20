module Cyrax::Extensions
  module HasService
    extend ActiveSupport::Concern

    # Builds and returns a collection response for Rails
    # @return [Cyrax::Response] response
    def collection
      respond_with build_collection, name: collection_name, present: :collection
    end
    # Overrides collection with read_all
    alias_method :read_all, :collection
    alias_method :read_all!, :collection

    # Builds a new resource without saving to DB
    # Runs Model.new (before saving)
    # Used for :new action in controller
    # @return [Cyrax::Response] response
    def build
      respond_with build_resource(nil)
    end
    alias_method :build!, :build

    # Creates a new resource and persists to DB
    # Used for :create action in controller
    # @return [Cyrax::Response] response
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

    # Reads a single item from the DB
    # Used for :show action in controller
    # @return [Cyrax::Response] response
    def read(&block)
      resource = find_resource(params[:id])
      block.call(resource) if block_given?
      respond_with resource
    end
    alias_method :read!, :read
    alias_method :edit, :read
    alias_method :edit!, :read

    # Updates a single item and persists to DB
    # Used for :update action in controller
    # @return [Cyrax::Response] response
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

    # Destroys a resource from the DB
    # Used for :destroy action in controller
    # @return [Cyrax::Response] response
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

    # Finds and returns a single item from the DB
    # @param id [int] ID of item
    # @return [object] The object
    def find_resource(id)
      resource_scope.find(id)
    end

    # Instantiates the resource
    # @param id [int] ID or nil if you want a new object
    # @param attributes [hash] Attributes you want to add to the resource
    # @return [object] The object
    def build_resource(id, attributes = {})
      if id.present?
        resource = find_resource(id)
        resource.attributes = attributes
        resource
      else
        resource_scope.new(default_resource_attributes.merge(attributes))
      end
    end

    # Saves a resource
    # @param resource [object] The resource to save
    def save_resource(resource)
      resource.save
    end

    # Remove a resource
    # Calls destroy method on resource
    # @param resource [object] The resource to destroy
    def delete_resource(resource)
      resource.destroy
    end

    # Returns a collection of the resource we are calling.
    #
    # If you want your resource to return something interesting, you should override the resource_scope method.
    # Otherwise by default it will return the constantized model name and it will call .all on it during presentation.
    #
    # @return [type] The collection
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
