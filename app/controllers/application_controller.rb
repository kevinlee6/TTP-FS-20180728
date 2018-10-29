class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_sign_up_params, if: :devise_controller?

  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
  end

  # def authenticate_user
  #   redirect_to new_user_registration_url unless user_signed_in?
  # end
end
