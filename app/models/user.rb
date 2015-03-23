class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

 validates :top_3_interests, length: {maximum: 3, too_long: " is limited to %{count} interests"}
 validates_presence_of :first_name, :last_name, :stage_of_career, :top_3_interests, :current_goal, :peer_industry, :primary_industry
 after_validation :check_industry

  def self.connect_to_linkedin(auth, signed_in_resource =nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        p user = User.create(first_name:auth.info.first_name, last_name:auth.info.last_name, provider:auth.provider, uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20] )
      end
    end
  end

  def check_industry
    if self.primary_industry == "Other" || self.primary_industry == nil
      self.waitlist = true
    else
      self.waitlist = false
    end
  end
end
