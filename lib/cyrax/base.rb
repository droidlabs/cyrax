require 'has_active_logger'
class Cyrax::Base
  include HasActiveLogger::Mixin
  include Cyrax::Extensions::HasResponse

  attr_accessor :params, :accessor, :options

  # Creates a new Cyrax resource
  #
  # @param options [Hash] Options to pass in. You need `:as` and `:params`
  #   :as defines the accessor
  #   :params are parameters passed by the controller usually
  #   :serializer overrides resource serializer
  #   :decorator overrides resource serializer
  #
  # @example Instantiating a new resource
  #     Products::UserResource.new(as: current_user, params: params)
  def initialize(options = {})
    @accessor = options[:as]
    # Action Pack 5 do not allow to initialize ActionController::Parameters with nil
    @params = wrap_params(options[:params] || {})
    @options = options
  end

  def wrap_params(params)
    if Cyrax.strong_parameters && defined?(ActionController) &&
      !params.is_a?(ActionController::Parameters)
      ActionController::Parameters.new(params)
    else
      params
    end
  end
end
