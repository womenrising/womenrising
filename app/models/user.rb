# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  encrypted_password          :string(255)      default(""), not null
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  created_at                  :datetime
#  updated_at                  :datetime
#  provider                    :string(255)
#  uid                         :string(255)
#  first_name                  :string(255)
#  last_name                   :string(255)
#  mentor                      :boolean          default(FALSE)
#  primary_industry            :string(255)
#  stage_of_career             :integer
#  mentor_industry             :string(255)
#  peer_industry               :string(255)
#  current_goal                :string(255)
#  top_3_interests             :text             default([]), is an Array
#  live_in_detroit             :boolean          default(TRUE)
#  waitlist                    :boolean          default(TRUE)
#  is_participating_next_month :boolean          default(FALSE)
#  is_assigned_peer_group      :boolean          default(FALSE)
#  mentor_times                :integer          default(1)
#  mentor_limit                :integer          default(1)
#  is_participating_this_month :boolean
#  image_url                   :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable
         # :recoverable, :rememberable, :trackable, :validatable,  :registerable

  has_many :mentors, class_name: "Mentor", foreign_key: "mentor_id"
  has_many :mentees, class_name: "Mentor", foreign_key: "mentee_id"

  has_many :peer_group_users
  has_many :peer_groups, through: :peer_group_users

  validates :top_3_interests, length: { maximum: 3, too_long: " is limited to %{count} interests" }
  validates_presence_of :first_name, :last_name
  validates_presence_of :mentor_industry, if: :mentor
  after_validation :check_industry

  CURRENT_GOALS = [
    "Rising the ranks / breaking the glass ceiling",
    "Switching industries",
    "Finding work/life balance"
  ]

  STAGE_OF_CAREER = [
    "Intern/Apprentice/Aspiring",
    "Gaining a foothold",
    "Management / Senior",
    "Director/VP/Chief Architect",
    "C-Level/Founder"
  ]

  def self.connect_to_linkedin(auth, signed_in_resource =nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    image_url = auth.extra.raw_info.pictureUrls.values[1][0]
    if user
      user.update_attributes(image_url: image_url)
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.update_attributes(image_url: image_url)
        return registered_user
      else
        user = User.create(first_name:auth.info.first_name, last_name:auth.info.last_name, provider:auth.provider, uid:auth.uid, email:auth.info.email, image_url:image_url,  password:Devise.friendly_token[0,20] )

        action = :new_user
        message  = "#{user.id} is a new user"
        SlackNotification.notify(action, message)

        UserMailer.welcome_mail(user).deliver
        return user
      end
    end
  end

  def self.update_month
    # start
    action = :update_month_start
    message  = "started update month"
    SlackNotification.notify(action, message)

    PeerGroup.generate_groups

    User.find_each do |user|
      if user.is_participating_this_month
        user.update(
          is_participating_this_month: false,
          is_assigned_peer_group: false,
          mentor_times: user.mentor_limit
        )
      else
        user.update(mentor_times: 0)
      end
    end

    # finish
    action = :update_month_finish
    message  = "finished update month"
    SlackNotification.notify(action, message)
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

  def get_image_url
    self.image_url ? self.image_url : "icons/yello_person.png"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
