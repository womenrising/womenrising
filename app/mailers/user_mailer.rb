class UserMailer < ActionMailer::Base
  default from: "info@womenrising.co"

  def welcome_mail(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Women Rising!")
  end

  def mentor_mail(mentor_match)
    @mentor_match = mentor_match
    @mentor = mentor_match.mentor
    @mentee = mentor_match.mentee
    mail(to: @mentor.email, subject: "#{@mentee.first_name} has requested to learn with you")
  end

  def mentee_mail(mentor_match)
    @mentor_match = mentor_match
    @mentor = mentor_match.mentor
    @mentee = mentor_match.mentee
    mail(to: @mentee.email, subject: "You have requested to be mentored by #{@mentor.first_name}")
  end

  def peer_mail(peer_group) 
    @peers = peer_group.users
    return if @peers.empty?
    mail(to: @peers.map(&:email), subject: 'Your "Women Rising" matches for this month!')
  end

  def peer_unavailable_mail(indv)
    @indv = indv
    mail(to: @indv.email, subject: '"Women Rising" could not match you this month :(')
  end
end
