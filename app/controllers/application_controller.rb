class ApplicationController < ActionController::Base
  protected
  def authenticate_user
    redirect_to new_user_registration_url unless user_signed_in?
  end
end
