module Cyrax::Extensions
  module HasResponse
    extend ActiveSupport::Concern
    STATUS_VALUES = {
      created: 201,
      no_content: 204,
      bad_request: 400,
      not_allowed: 403
    }

    def assign_resource(resource_name, resource, options = {})
      if options[:decorator]
        resource = Cyrax::Presenter.present(resource, options)
      end
      @_assignments ||= {}
      @_assignments[resource_name.to_sym] = resource
    end

    def assignment(resource_name)
      @_assignments ||= {}
      @_assignments[resource_name]
    end

    def add_error(key, value = nil)
      if value.blank?
        raise "Use key-value syntax for adding errors"
      end
      @_errors ||= {}
      @_errors[key.to_sym] = value
    end

    def add_error_unless(key, value, condition)
      add_error(key, value) unless condition
    end

    def sync_errors_with(model)
      model = model.to_model if model.respond_to?(:to_model)
      return unless model
      (@_errors || {}).each do |key, value|
        next unless model.respond_to?(key)
        model.errors.add key, value unless model.errors.include?(key)
      end
      if model.errors.messages.present?
        model.errors.messages.each do |key, value|
          add_error key, value
        end
      end
    end

    def sync_errors_with?(model)
      model = model.to_model if model.respond_to?(:to_model)
      model && model.respond_to?(:errors) &&
      model.errors.respond_to?(:messages)
    end

    def reset_errors
      @_errors = {}
    end

    def set_message(message)
      if message.is_a?(Symbol)
        service_name = self.class.name.demodulize.underscore
        @_message = I18n.t("cyrax.#{service_name}.#{message}", default: "#{response_name.titleize} successfully #{message}")
      else
        @_message = message
      end
    end

    def set_status(status)
      if status.is_a?(Symbol)
        status = STATUS_VALUES[status]
      end
      @_status = status
    end

    def response_name
      self.class.name.demodulize.underscore
    end

    # Generates the response for to pass to the Rails controller
    # @param result The data you want to respond with - can be an Active Record Relation, the class of the Model itself (e.g. Product)
    # @param options [Hash] Options
    def respond_with(result, options = {})
      options[:as] ||= accessor
      options[:assignments] =  @_assignments
      name = options[:name] || response_name
      result = result.result.to_model if result.is_a?(Cyrax::Response)
      if sync_errors_with?(result)
        sync_errors_with(result)
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
      response.status = @_status
      response
    end
  end
end
