module Cyrax::Extensions
  module HasService
    extend ActiveSupport::Concern

    # Builds and returns a collection response for Rails
    # @return [Cyrax::Response] response
    def read_all(&block)
      authorize_resource!(:read_all, resource_class)
      collection = repository.find_all
      block.call(collection) if block_given?
      respond_with collection, name: collection_name, present: :collection
    end
    alias_method :read_all!, :read_all

    # Builds a new resource without saving to DB
    # Runs Model.new (before saving)
    # Used for :new action in controller
    # @return [Cyrax::Response] response
    def build(&block)
      resource = repository.build(nil)
      authorize_resource!(:build, resource)
      block.call(resource) if block_given?
      respond_with resource
    end
    alias_method :build!, :build

    # Creates a new resource and persists to DB
    # Used for :create action in controller
    # @return [Cyrax::Response] response
    def create(custom_attributes = nil, &block)
      resource = repository.build(nil, custom_attributes||resource_attributes)
      authorize_resource!(:create, resource)
      transaction do
        if repository.save(resource)
          set_message(:created)
          block.call(resource) if block_given?
        end
      end
      respond_with(resource)
    end
    alias_method :create!, :create

    # Reads a single item from the DB
    # Used for :show action in controller
    # @return [Cyrax::Response] response
    def read(&block)
      resource = repository.find(resource_params_id)
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
      resource = repository.build(resource_params_id, custom_attributes||resource_attributes)
      authorize_resource!(:update, resource)
      transaction do
        if repository.save(resource)
          set_message(:updated)
          block.call(resource) if block_given?
        end
      end
      respond_with(resource)
    end
    alias_method :update!, :update

    # Destroys a resource from the DB
    # Used for :destroy action in controller
    # @return [Cyrax::Response] response
    def destroy(&block)
      resource = repository.find(resource_params_id)
      authorize_resource!(:destroy, resource)
      transaction do
        repository.delete(resource)
        block.call(resource) if block_given?
      end
      respond_with(resource)
    end
    alias_method :destroy!, :destroy

    # Authorize a resource
    # Should be called on each service method and should be implemented on each resource.
    # Implementation may raise an exception which may be handled by controller.
    # @param action [Symbol] The action to authorize
    # @param resource [object] The resource to authorize
    def authorize_resource!(action, resource)
      # raise AuthorizationError
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

    # DEPRECATED METHODS
    def resource_scope
      respository.scope
    end
    def build_collection
      respository.find_all
    end
    def find_resource(id)
      respository.find(id)
    end
    def save_resource(resource)
      respository.save(resource)
    end
    def delete_resource(resource)
      respository.delete(resource)
    end
  end
end
