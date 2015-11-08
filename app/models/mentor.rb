class Mentor < ActiveRecord::Base
  validate  :is_question_empty, :not_on_waitlist, :have_available_mentors, :is_question

  belongs_to :mentee, class_name: "User", foreign_key: 'mentee_id'
  belongs_to :mentoring, class_name: "User", foreign_key: 'mentor_id'

  def is_question_empty
    errors.add("You must submit a question" ,'In order to request a mentor you must not leave the question box blank.') if self.question.empty?
  end

  def is_question
    errors.add("In order to receive a mentor match, you must submit a specific question! What is your question? " ,' Some examples from last round include: "How do I ask for a raise?", "How can I make time for both my significant other while being so busy?" or "How can I get my first job as a developer?"') if self.question[-1] != "?"
  end

  def not_on_waitlist
    errors.add("You are currently Waitlisted","members who are waitlisted cannot get mentors") if self.mentee.waitlist
  end

  def have_available_mentors
    errors.add("We currently do not have mentors available for you at this time", "We are sorry for the inconvenience") if choose_mentor.nil?
  end

  before_save do
    self.mentor_id = choose_mentor.id
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
