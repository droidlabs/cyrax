module Cyrax::Extensions
  module HasResponse
    extend ActiveSupport::Concern

    def add_error(key, value)
      if value.blank?
        raise "Use key-value syntax for adding errors"
      end
      @_errors ||= {}
      @_errors[key.to_sym] = value
    end

    def assign_resource(resource_name, resource, options = {})
      if options[:decorator]
        resource = Cyrax::Presenter.present(resource, options)
      end
      @_assignments ||= {}
      @_assignments[resource_name.to_sym] = resource
    end

    def add_error_unless(key, value, condition)
      add_error(key, value) unless condition
    end

    def add_errors_from(model)
      if model && model.errors.messages.present?
        model.errors.messages.each do |key, value|
          add_error key, value
        end
      end
    end

    def add_errors_from?(model)
      model = model.to_model if model.respond_to?(:to_model)
      model && model.respond_to?(:errors) && 
      model.errors.respond_to?(:messages)
    end

    def reset_errors
      @_errors = {}
    end

    def set_message(message)
      @_message = message
    end

    def response_name
      self.class.name.demodulize.underscore
    end

    # Generates the response for to pass to the Rails controller
    # @param result The data you want to respond with - can be an Active Record Relation, the class of the Model itself (e.g. Product)
    # @param options [Hash] Options
    def respond_with(result, options = {})
      options[:as] ||= accessor
      name = options[:name] || response_name
      result = result.result.to_model if result.is_a?(Cyrax::Response)
      if add_errors_from?(result)
        add_errors_from(result)
      end
      if respond_to?(:decorable?) && decorable?
        options = {decorator: decorator_class}.merge(options)
      end
      if respond_to?(:serializable?) && serializable?
        options = {serializer: serializer_class}.merge(options)
      end
      result = Cyrax::Presenter.present(result, options)
      response = Cyrax::Response.new(name, result, options)
      response.message = @_message
      response.errors = @_errors
      response.assignments = @_assignments
      response
    end
  end
end
