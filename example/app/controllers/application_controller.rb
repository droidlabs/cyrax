class ApplicationController < ActionController::Base
  helper_method :service_response, :resource_name, :resource

  def respond_with(*args)
    if args && args.first && args.first.is_a?(Cyrax::Response)
      response, options = *args
      default_options = {notice: response.notice, error: response.error}
      set_resource_from(response)
      flash[:notice] = response.notice if response.notice.present?
      super(response.result, default_options.merge(options || {}))
    else
      super(*args)
    end
  end

  def set_resource_from(response)
    instance_variable_set("@service_response", response)
    instance_variable_set("@#{resource_name}", response.result)
  end

  def service_response
    @service_response
  end

  def resource_name
    @service_response.resource_name
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end
end
