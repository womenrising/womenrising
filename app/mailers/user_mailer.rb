class UserMailer < ActionMailer::Base
  default from: "info@womenrising.co"

  def mentoring(mentor, mentee)
    @mentor = mentor
    @mentee = mentee
    mail(to: @mentor.email, subject: "#{mentee.first_name} has requested to learn with you")
  end
end
