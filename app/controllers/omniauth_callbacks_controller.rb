class Users::OmniauthCallbacksController < Devise::OmniauthCallbackController

  def linkedin
    auth = env["omniauth.auth"]
    @user = User.connect_to_linkedin(request.env["omniauth.auth"],current_user)
    if @user.presisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sigh_in_and_redirect @user, :event => :authentication
    else
      session["devise.linkedin_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
