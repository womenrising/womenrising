class Users::OmniauthCallbacksController < Devise::OmniauthCallbackController

  def linkedin
    omniauth_hash = env["omniauth.auth"]
    cuttent_user.create_linkedin_connection(
      :token => omniauth_hash["extra"]["access_token"].token,
      :secret => omniauth_hash["extra"]["access_token"].secret,
      :uid => omniauth_hash["uid"]
    )
    redirect_to root_path, :notice => "You've successfully connected your LinkedIn account."
  end
end
