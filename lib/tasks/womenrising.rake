namespace :womenrising do

  desc 'Run the PeerGroup monthly match'
  task :peer_group_monthly_match => :environment do
    # run the peer group matches
    User.update_month
  end

  desc 'Match mentors'
  task :mentor_matches => :environment do
    @available_mentorships = Mentorship.where(mentor_id: nil)
    @available_mentorships.each do |mentorship|
      mentorship.update(mentor: mentorship.choose_mentor)
    end
  end
end
