class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def restrict_admin_access
    if !admin?
      flash[:alert] = "Admin access only!"
      redirect_to movies_path
    end
  end

  def admin?
    session[:admin] == 1 ? true : false
  end

  helper_method :current_user, :admin?
  
end
