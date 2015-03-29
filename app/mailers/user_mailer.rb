class UserMailer < ActionMailer::Base
  default from: "info@womenrising.co"

  def welcome_mail(user)
    @user
    mail(to: @user.email, subject: "Welcome to Women Rising!")
  end

  def mentor_mail(mentor_match)
    @mentor_match = mentor_match
    @mentor = mentor_match.mentoring
    @mentee = mentor_match.mentee
    mail(to: @mentor.email, subject: "#{@mentee.first_name} has requested to learn with you")
  end

  def mentee_mail(mentor_match)
    @mentor_match = mentor_match
    @mentor = mentor_match.mentoring
    @mentee = mentor_match.mentee
    mail(to: @mentee.email, subject: "You have requested to be mentored by #{@mentor.first_name}")
  end

end
