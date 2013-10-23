module Cyrax::ControllerHelper
  def respond_with(*args)
    if args.present? && args.first.is_a?(Cyrax::Response)
      response, options = *args
      default_options = {
        notice: response.notice,
        error: response.error
      }
      set_resource_from(response)
      flash[:notice] = response.notice if response.notice.present?
      flash[:error] = response.error if response.error.present?

      # convert result to model if possible
      result = response.result
      result = result.to_model if result.respond_to?(:to_model)

      super(result, default_options.merge(options || {}))
    else
      super(*args)
    end
  end

  def set_resource_from(response)
    instance_variable_set("@#{response.resource_name}", response.result)
    response.assignments.each do |key, value|
      instance_variable_set("@#{key}", value)
    end if response.assignments.present? && response.assignments.is_a?(Hash)
  end
end
