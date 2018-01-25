class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    auth = env['omniauth.auth']
    @user = User.connect_to_linkedin(request.env['omniauth.auth'],current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.linkedin_uid'] = request.env['omniauth.auth']
      redirect_to root_path
    end
  end

  skip_before_action :verify_authenticity_token, only: :developer
  alias_method :developer, :linkedin
end
