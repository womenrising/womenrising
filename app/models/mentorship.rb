# == Schema Information
#
# Table name: mentorships
#
#  id         :integer          not null, primary key
#  mentor_id  :integer
#  mentee_id  :integer
#  question   :text
#  created_at :datetime
#  updated_at :datetime
#

class Mentorship < ActiveRecord::Base
  validate :not_on_waitlist
  validates_presence_of :question

  belongs_to :mentee, class_name: "User", foreign_key: 'mentee_id'
  belongs_to :mentor, class_name: "User", foreign_key: 'mentor_id'

  scope :mentored_by, -> (user) { where mentor: user }
  scope :mentoring, -> (user) { where mentee: user }

  def not_on_waitlist
    errors.add("You are currently Waitlisted","members who are waitlisted cannot get mentors") if self.mentee.waitlist
  end

  after_save do
    if mentor_id_changed? && mentor_id.present?
      mentor.update(mentor_times: mentor.mentor_times -=1)
    end
  end

  def choose_mentor
    choice = get_possible_mentors
    if choice.length > 3
      choice -= get_previous_mentors.pop(3)
    else
      choice
    end
    choice.sample
  end

  def send_mail
    UserMailer.mentor_mail(self).deliver
    UserMailer.mentee_mail(self).deliver
  end

private
  def get_possible_mentors
    industry_key = MentorIndustry.find_by_name(mentee.primary_industry).id

    if mentee.stage_of_career == 5
      User.where(mentor: true, waitlist: false)
          .where( "mentor_times > ?", 0)
          .where.not(id: mentee.id)
          .joins(:mentor_industry_users).where("mentor_industry_users.mentor_industry_id" => industry_key)
          .joins(:mentor_industry_users).where("mentor_industry_users.career_stage" => 5)
    else
      User.where(mentor: true, waitlist: false)
          .where("mentor_times > ?", 0)
          .joins(:mentor_industry_users).where("mentor_industry_users.mentor_industry_id" => industry_key)
          .joins(:mentor_industry_users).where("mentor_industry_users.career_stage > ?", mentee.stage_of_career)
    end
  end

  def get_previous_mentors
    all_mentors = []
    Mentorship.mentoring(mentee).each do |mentor|
      all_mentors << mentor
    end
    all_mentors
  end

end
