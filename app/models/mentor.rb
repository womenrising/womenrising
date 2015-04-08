class Mentor < ActiveRecord::Base
  validates_presence_of :question
  validate :not_on_waitlist, :have_avalible_mentors

  belongs_to :mentee, class_name: "User", foreign_key: 'mentee_id'
  belongs_to :mentoring, class_name: "User", foreign_key: 'mentor_id'

  def not_on_waitlist
    errors.add(:waitlisted,"members cannot get mentors") if self.mentee.waitlist
  end

  def have_avalible_mentors
    errors.add(:mentors, "are not avalible for your currently") if choose_mentor.nil?
  end

  after_save do
    mentoring.update(mentor_times: mentoring.mentor_times -=1)
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
      User.where(is_participating_this_month: true, mentor: true, waitlist: false, stage_of_career: 5).where( "mentor_times > ?", 0).where(mentor_industry: mentee.primary_industry).where("id != ?", mentee.id)
    else
      User.where(is_participating_this_month: true, mentor: true, waitlist: false).where("stage_of_career > ? AND mentor_times > ?", mentee.stage_of_career, 0).where(mentor_industry: mentee.primary_industry)
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
