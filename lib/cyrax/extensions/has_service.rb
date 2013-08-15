module Cyrax::Extensions
  module HasService
    extend ActiveSupport::Concern

    def collection
      respond_with wrapped_collection, name: collection_name
    end

    def build
      respond_with build_resource(nil)
    end

    def create(custom_attributes=nil)
      resource = build_resource(nil, custom_attributes||resource_attributes)
      invoke_callback(:before_create, resource)
      invoke_callback(:before_save, resource)
      if resource.save
        invoke_callback(:after_create, resource)
        invoke_callback(:after_save, resource)
        set_message("#{resource_name.titleize} successfully created")
      else
        add_errors_from(resource)
      end
      respond_with(resource)
    end

    def read
      respond_with find_resource(params[:id])
    end
    alias_method :edit, :read


    def update(custom_attributes=nil)
      resource = build_resource(params[:id], custom_attributes||resource_attributes)
      invoke_callback(:before_update, resource)
      invoke_callback(:before_save, resource)
      if resource.save
        invoke_callback(:after_update, resource)
        invoke_callback(:after_save, resource)
        set_message("#{resource_name.titleize} successfully updated")
      else
        add_errors_from(resource)
      end
      respond_with(resource)
    end

    def destroy
      resource = find_resource(params[:id])
      invoke_callback(:before_destroy, resource)
      resource.destroy
      invoke_callback(:after_destroy, resource)
      respond_with(resource)
    end
  end
end
