class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(linkedin)
    return '/admin' if current_admin_user.try(:class) == AdminUser

    if current_user.sign_in_count == 1 || current_user.waitlist == true
      edit_user_path(current_user)
    else
      user_path(current_user)
    end
  end

  def auth_user
    redirect_to root_path unless user_signed_in?
  end
end
