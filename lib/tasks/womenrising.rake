namespace :womenrising do

  desc 'Run the PeerGroup monthly match'
  task :peer_group_monthly_match => :environment do
    if DateTime.current.day == 1
      User.match_peers_and_update_users
    end
  end

  desc 'Match mentors'
  task :mentor_matches => :environment do
    @available_mentorships = Mentorship.where(mentor_id: nil)
    @available_mentorships.order(:created_at).each do |mentorship|
      mentorship.update(mentor: mentorship.choose_mentor)

      if mentorship.mentor_id
        mentorship.send_mail

        message  = "User id #{mentorship.mentor_id} is a now mentoring User #{mentorship.mentee_id}"
        SlackNotification.notify(:new_mentor, message)
      end
    end
  end
end
