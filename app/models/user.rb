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
#  waitlist                    :boolean          default(TRUE)
#  mentor_times                :integer          default(1)
#  mentor_limit                :integer          default(1)
#  is_participating_this_month :boolean
#  image_url                   :string(255)
#  location_id                 :integer
#  zip_code                    :string(10)
#  linkedin_url                :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_location_id           (location_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable

  has_many :peer_group_users
  has_many :peer_groups, through: :peer_group_users
  belongs_to :location

  validates :top_3_interests, length: { maximum: 3, too_long: ' is limited to %{count} interests' }
  validates_presence_of :first_name, :last_name

  has_many :mentor_industry_users, dependent: :destroy
  has_many :mentor_industries, through: :mentor_industry_users
  accepts_nested_attributes_for :mentor_industry_users, allow_destroy: true

  after_validation :check_industry

  before_save :ensure_location_or_zip

  scope :mentors, -> { where(mentor: true) }
  scope :viewable_by, -> (user) { where(id: user.related_user_ids) }

  CURRENT_GOALS = [
    'Rising the ranks / breaking the glass ceiling',
    'Switching industries',
    'Finding work/life balance'
  ]

  PRIMARY_INDUSTRY = [
    'Business',
    'Technology',
    'Startup'
  ]

  TOP_3_INTERESTS = [
    'Arts',
    'Music',
    'Crafting',
    'Home improvement / Decorating',
    'Being a mom',
    'Dogs',
    'Cats',
    'Watching Sports',
    'Outdoors / Hiking',
    'Exercise',
    'Biking',
    'Yoga',
    'Running',
    'Beer',
    'Wine',
    'Traveling','
    Local events',
    'Reading',
    'Photography',
    'Movies',
    'Cooking / Eating / Being a foodie',
    'Social issues / volunteering',
    'Video Games'
  ]

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first
    image_url = auth.extra.raw_info.pictureUrls.values[1][0] rescue nil
    linkedin_url = auth.extra.raw_info.publicProfileUrl
    if user
      user.update_attributes(image_url: image_url, linkedin_url: linkedin_url)
    else
      user = User.create(
        auth.info.slice(:first_name, :last_name, :email).merge(
          auth.slice(:provider, :uid)
        ).merge(
          image_url: image_url,
          linkedin_url: linkedin_url,
          password: Devise.friendly_token[0,20]
        ).to_h
      )

      action = :new_user
      message  = "#{user.id} is a new user"
      SlackNotification.notify(action, message)

      UserMailer.welcome_mail(user).deliver_now
    end
    return user
  end

  def self.match_peers_and_update_users
    # start
    action = :match_peers_and_update_users_start
    message  = 'started update month'
    SlackNotification.notify(action, message)

    PeerGroup.generate_groups

    User.find_each do |user|
      if user.is_participating_this_month
        user.update(
          is_participating_this_month: false,
          mentor_times: user.mentor_limit
        )
      else
        user.update(mentor_times: 0)
      end
    end

    # finish
    action = :match_peers_and_update_users_finish
    message  = 'finished update month'
    SlackNotification.notify(action, message)
  end

  def mentorships
    Mentorship.where('mentor_id = :user_id OR mentee_id = :user_id', user_id: id)
  end

  def check_industry
    if self.primary_industry == 'Other' || self.primary_industry == nil || self.peer_industry == nil || self.top_3_interests == [] || self.current_goal == nil
      self.waitlist = true
    else
      self.waitlist = false
    end
  end

  def mentor_limit= new_mentor_limit
    mentor_diff = new_mentor_limit.to_i - self.mentor_limit
    self.mentor_times = [self.mentor_times + mentor_diff, 0].max

    super
  end

  def get_image_url
    self.image_url ? self.image_url : 'icons/yello_person.png'
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def stage_of_career_name
    STAGE_OF_CAREER[self.stage_of_career - 1] rescue nil
  end

  def current_peer_group
    peer_groups.current.first
  end

  def peers
    if current_peer_group
      current_peer_group.users - [self]
    else
      []
    end
  end

  def my_mentors
    Mentorship.mentoring(self).all.map(&:mentor_id).compact
  end

  def my_mentees
    Mentorship.mentored_by(self).all.map(&:mentee_id).compact
  end

  def related_user_ids
    [id, peers.map(&:id), my_mentors, my_mentees].flatten
  end

  private

  def ensure_location_or_zip
    self.zip_code = nil if location_id
  end
end
