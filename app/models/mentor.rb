class Mentor < ActiveRecord::Base

  belongs_to :mentee, class_name: "User", foreign_key: 'mentee_id'
  belongs_to :mentoring, class_name: "User", foreign_key: 'mentor_id'

  def get_possible_mentors(industry)
    User.where(is_participating_next_month: true, mentor: true, waitlist: false).where("stage_of_career > ? AND mentor_times > ?", current_user.stage_of_career, 0).where(mentor_industry: industry)
  end
end
