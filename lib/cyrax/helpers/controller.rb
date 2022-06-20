module Cyrax::ControllerHelper
  def respond_with(*args, &block)
    if args.present? && args.first.is_a?(Cyrax::Response)
      response, options = *args
      options = {
        notice: response.notice,
        error: response.error
      }.merge(options || {})

      # override status if needed
      options[:status] = response.status if response.status

      # convert result to model if possible
      result = response.result
      result = result.to_model if result.respond_to?(:to_model)

      respond_to do |format|
        format.html do
          # set flashes
          if response.success?
            flash[:notice] = options[:notice] if options[:notice].present?
          else
            flash.now[:notice] = options[:notice] if options[:notice].present?
            flash.now[:error] = options[:error] if options[:error].present?
          end
          set_resource_from(response)
        end
        format.json do
          render json: MultiJson.dump(response.as_json), status: options[:status] || 200
        end
        format.any do
          set_resource_from(response)
          super(response, options, &block)
        end
      end
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
