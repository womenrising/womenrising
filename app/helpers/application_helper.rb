module ApplicationHelper
  def default_omniauth_authorize_path
    if Rails.env.production?
      user_linkedin_omniauth_authorize_path
    else
      user_developer_omniauth_authorize_path
    end
  end
end
