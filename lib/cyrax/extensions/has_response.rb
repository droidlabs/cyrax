module Cyrax::Extensions
  module HasResponse
    extend ActiveSupport::Concern

    def add_error(error)
      @_errors ||= []
      @_errors << error
    end

    def assign_resource(resource_name, resource, options = {})
      if options[:decorator]
        resource = Cyrax::Presenter.present(resource, options)
      end
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

    def response_name
      self.class.name.demodulize.underscore
    end

    def respond_with(result, options = {})
      options[:as] ||= accessor
      name = options[:name] || response_name
      result = result.result.to_model if result.is_a?(Cyrax::Response)
      if respond_to?(:decorable?) && decorable?
        options = {decorator: decorator_class}.merge(options)
      end
      if respond_to?(:seializable?) && seializable?
        options = {serializer: serializer_class}.merge(options)
      end
      result = Cyrax::Presenter.present(result, options)
      response = Cyrax::Response.new(name, result)
      response.message = @_message
      response.errors = @_errors
      response.assignments = @_assignments
      response
    end
  end
end
