class ApplicationController < ActionController::Base
  include Cyrax::ControllerHelper

  def configure_devise_attributes
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(Users::AccountResource.accessible_attributes)
    end
  end
end
