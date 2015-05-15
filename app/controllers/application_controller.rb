class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private
  def not_authorized
    flash[:danger] = "Not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def not_authenticated
    flash[:warning] = "Please login first"
    redirect_to login_path
  end

end
