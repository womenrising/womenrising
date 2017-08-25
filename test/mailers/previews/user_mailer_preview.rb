class UserMailerPreview < ActionMailer::Preview
  def peer_mail
    UserMailer.peer_mail(PeerGroup.first)
  end
end
