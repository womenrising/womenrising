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
  belongs_to :mentoring, class_name: "User", foreign_key: 'mentor_id'

  def not_on_waitlist
    errors.add("You are currently Waitlisted","members who are waitlisted cannot get mentors") if self.mentee.waitlist
  end

  after_save do
    if mentor_changed? && mentor.present?
      mentoring.update(mentor_times: mentoring.mentor_times -=1)
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
    if mentee.stage_of_career == 5
      User.where(mentor: true, waitlist: false, stage_of_career: 5).where( "mentor_times > ?", 0).where(mentor_industry: mentee.primary_industry).where("id != ?", mentee.id)
    else
      User.where(mentor: true, waitlist: false).where("stage_of_career > ? AND mentor_times > ?", mentee.stage_of_career, 0).where(mentor_industry: mentee.primary_industry)
    end
  end

  def get_previous_mentors
    all_mentors = []
    mentee.mentees.each do |mentor|
      all_mentors << mentor
    end
    all_mentors
  end

end
