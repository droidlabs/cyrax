module Cyrax::Extensions
  module HasService
    VALIDATION_ERROR_STATUS = 422
    extend ActiveSupport::Concern

    # Builds and returns a collection response for Rails
    # @return [Cyrax::Response] response
    def read_all(&block)
      authorize_resource!(:read_all, resource_class)
      collection = build_collection
      block.call(collection) if block_given?
      respond_with collection, name: collection_name, present: :collection
    end
    # Overrides collection with read_all
    alias_method :read_all!, :read_all

    # Builds a new resource without saving to DB
    # Runs Model.new (before saving)
    # Used for :new action in controller
    # @return [Cyrax::Response] response
    def build(&block)
      resource = build_resource(nil)
      authorize_resource!(:build, resource)
      block.call(resource) if block_given?
      respond_with resource
    end
    alias_method :build!, :build

    # Creates a new resource and persists to DB
    # Used for :create action in controller
    # @return [Cyrax::Response] response
    def create(custom_attributes = nil, &block)
      resource = build_resource(nil, custom_attributes||resource_attributes)
      authorize_resource!(:create, resource)
      transaction do
        if save_resource(resource)
          set_message(:created)
          block.call(resource) if block_given?
        elsif Cyrax.automatically_set_invalid_status
          set_status VALIDATION_ERROR_STATUS
        end
      end
      respond_with(resource)
    end
    alias_method :create!, :create

    # Reads a single item from the DB
    # Used for :show action in controller
    # @return [Cyrax::Response] response
    def read(&block)
      resource = find_resource(resource_params_id)
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
      resource = build_resource(resource_params_id, custom_attributes||resource_attributes)
      authorize_resource!(:update, resource)
      transaction do
        if save_resource(resource)
          set_message(:updated)
          block.call(resource) if block_given?
        elsif Cyrax.automatically_set_invalid_status
          set_status VALIDATION_ERROR_STATUS
        end
      end
      respond_with(resource)
    end
    alias_method :update!, :update

    # Destroys a resource from the DB
    # Used for :destroy action in controller
    # @return [Cyrax::Response] response
    def destroy(&block)
      resource = find_resource(resource_params_id)
      authorize_resource!(:destroy, resource)
      transaction do
        delete_resource(resource)
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

    # Authorize a resource
    # Should be called on each service method and should be implemented on each resource.
    # Implementation may raise an exception which may be handled by controller.
    # @param action [Symbol] The action to authorize
    # @param resource [object] The resource to authorize
    def authorize_resource!(action, resource)
      # raise AuthorizationError
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

    def resource_params_id
      params[:id]
    end
  end
end
