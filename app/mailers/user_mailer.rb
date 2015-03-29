class UserMailer < ActionMailer::Base
  default from: "info@womenrising.co"

  def welcome(user)
    @user
    mail(to: @user.email, subject: "Welcome to Women Rising!")
  end

  def mentoring(mentor_match)
    @mentor_match = mentor_match
    @mentor = mentor_match.mentoring
    @mentee = mentor_match.mentee
    mail(to: @mentor.email, subject: "#{mentee.first_name} has requested to learn with you")
  end
end
