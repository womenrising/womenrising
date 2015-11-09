class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable
         # :recoverable, :rememberable, :trackable, :validatable,  :registerable

  has_many :mentors, class_name: "Mentor", foreign_key: "mentor_id"
  has_many :mentees, class_name: "Mentor", foreign_key: "mentee_id"
  has_many :peer1, class_name: "Peer", foreign_key: "peer1_id"
  has_many :peer2, class_name: "Peer", foreign_key: "peer2_id"
  has_many :peer3, class_name: "Peer", foreign_key: "peer3_id"
  has_many :peer4, class_name: "Peer", foreign_key: "peer4_id"
 validates :top_3_interests, length: {maximum: 3, too_long: " is limited to %{count} interests"}
 validates_presence_of :first_name, :last_name
 validates_presence_of :mentor_industry, if: :mentor
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
        user = User.create(first_name:auth.info.first_name, last_name:auth.info.last_name, provider:auth.provider, uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20] )
        UserMailer.welcome_mail(user).deliver
        return user
      end
    end
  end

  def self.update_month
    Peer.generate_groups
    User.all.each do |user|
      if user.is_participating_this_month
        user.update(is_participating_this_month: false, is_assigned_peer_group: false, mentor_times: user.mentor_limit)
      else
        user.update(mentor_times: 0)
      end
    end
  end

  def check_industry
    if self.primary_industry == "Other" || self.primary_industry == nil || self.peer_industry == nil || self.top_3_interests == [] || self.current_goal == nil
      self.waitlist = true
    else
      self.waitlist = false
    end
  end

  def mentor_times_change(new_mentor_limit)
    mentor_diff = new_mentor_limit.to_i - self.mentor_limit
    new_mentor_times = self.mentor_times + mentor_diff
    if new_mentor_times < 0
      return 0
    else
      return new_mentor_times
    end
  end
end
