module Cyrax::Extensions
  module HasResponse
    extend ActiveSupport::Concern

    def add_error(error)
      @_errors ||= []
      @_errors << error
    end

    def assign_resource(resource_name, resource)
      @_assignments ||= {}
      @_assignments[resource_name.to_sym] = resource
    end

    def add_error_unless(error, condition)
      add_error(error) unless condition
    end

    def add_errors_from(model)
      @_errors ||= []
      if model && model.errors.messages.present?
        model.errors.messages.each do |key, value|
          add_error "#{key}: #{value}"
        end
      end
    end

    def set_message(message)
      @_message = message
    end

    def respond_with(resource, custom_resource_name=nil)
      name = custom_resource_name||resource_name
      result = respond_to?(:decorator_class) ? decorator_class.new(resource) : resource
      response = Cyrax::Response.new(name, result)
      response.message = @_message
      response.errors = @_errors
      response.assignments = @_assignments
      response
    end
  end
end
