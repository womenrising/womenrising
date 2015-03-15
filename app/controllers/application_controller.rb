class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(linkedin)
    if current_user.sign_in_count == 1 || current_user.waitlist == true
      edit_user_path(current_user)
    else
      user_path(current_user)
    end
  end
end
