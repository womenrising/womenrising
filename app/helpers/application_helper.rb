module ApplicationHelper
  def default_omniauth_authorize_path
    user_omniauth_authorize_path(ENV['DEFAULT_OMNIAUTH_PROVIDER'] || :linkedin)
  end
end
