namespace :womenrising do

  desc 'Run the PeerGroup monthly match'
  task :peer_group_monthly_match => :environment do
    # run the peer group matches
    User.update_month
  end

  desc 'Match mentors'
  task :mentor_matches => :environment do
    @available_mentorships = Mentorship.where(mentor_id: nil)
    @available_mentorships.order(:created_at).each do |mentorship|
      mentorship.update(mentor: mentorship.choose_mentor)

      if mentorship.mentor_id
        mentorship.send_mail

        action = :new_mentor
        message  = "User id #{mentorship.mentor_id} is a now mentoring User #{mentorship.mentee_id}"
        SlackNotification.notify(action, message)
      end
    end
  end
end
