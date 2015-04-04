class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'
  belongs_to :peer4, class_name: "User", foreign_key: 'peer4_id'

    def group_peers
      frist = get_all_peers("Technology", 1)
      get_first_peer(first)
    end



  def get_first_peer(industry, stage_of_career)
    first_peer =  User.where(live_in_detroit:true, is_participating_this_month: true, waitlist: false, is_assigned_peer_group: false).where("peer_industry = ? AND stage_of_career = ?", industry, stage_of_career).sample
    peer_group = [first_peer]
  end

  def get_other_peers(peer_group)
    stage_of_career = adverage_stage_of_career
    min = stage_of_career > 1 ? (stage_of_career - 1) : 1
    max = stage_of_career < 5 ? (stage_of_career + 1) : 5
    industry = peer_group[0].peer_industry
    career_goal = peer_group[0].career_goal
    interests = peer_group[0].sample

    @peers = User.where(live_in_detroit:true, is_participating_next_month: true, waitlist: false, is_assigned_peer_group: false, peer_industry: @first_peer.peer_industry).where('stage_of_career >= ? AND stage_of_career <= ?', min, max, inerest)
  end

  def get_interests(peer_group)
    interests = []
    peer_group.each do |user|
      insterst += user.interests 
    end
    interests
  end

  def average_stage_of_career(peer_group)
    counter = 0
    peer_group.each do |user|
      counter += user.stage_of_career
    end
    counter / peer_group.length
  end

end
