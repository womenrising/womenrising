class Mentor < ActiveRecord::Base
  validates_presence_of :question

  belongs_to :mentee, class_name: "User", foreign_key: 'mentee_id'
  belongs_to :mentoring, class_name: "User", foreign_key: 'mentor_id'

  before_validation(on: :create) do
    self.mentor_id = choose_mentor.id
  end

  after_save do
    mentoring.update(mentor_times: mentoring.mentor_times -=1)
  end

  def get_possible_mentors
    User.where(is_participating_next_month: true, mentor: true, waitlist: false).where("stage_of_career > ? AND mentor_times > ?", mentee.stage_of_career, 0).where(mentor_industry: mentee.primary_industry)
  end

  def previous_mentors
    all_mentors = []
    mentee.mentees.each do |mentor|
      all_mentors << mentor
    end
    all_mentors
  end

  def choose_mentor
    choice = get_possible_mentors - previous_mentors.pop(3)
    choice.sample
  end
end
