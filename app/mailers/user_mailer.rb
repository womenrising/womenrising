class UserMailer < ActionMailer::Base
  default from: "info@womenrising.co"

  def welcome_mail(user)
    @user = user
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

  def four_peer_mail(peers)
    @peer1 = peers.peer1
    @peer2 = peers.peer2
    @peer3 = peers.peer3
    @peer4 = peers.peer4
    mail(to:  [@peer1.email, @peer2.email, @peer3.email, @peer4.email], subject: 'Your "Women Rising" matches for this month!')
  end

  def three_peer_mail(peers)
    @peer1 = peers.peer1
    @peer2 = peers.peer2
    @peer3 = peers.peer3
    mail(to:  [@peer1.email, @peer2.email, @peer3.email], subject: 'Your "Women Rising" matches for this month!')
  end

  def peer_unavailable_mail(indv)
    @indv = indv
    mail(to: @indv.email, subject: '"Women Rising" could not match you this month :(')
  end
   

end
