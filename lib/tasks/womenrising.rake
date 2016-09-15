namespace :womenrising do

  desc 'Run the PeerGroup monthly match'
  task :peer_group_monthly_match => :environment do
    # run the peer group matches
    User.update_month
  end

end
