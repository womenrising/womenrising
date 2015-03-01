class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.connect_to_linkedin(auth, signed_in_resource =nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.info.first_name, provider:auth.provider, uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20], )
      end
    end
  end
end
