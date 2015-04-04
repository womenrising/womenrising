class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'
  belongs_to :peer4, class_name: "User", foreign_key: 'peer4_id'

  attr_reader :interests

  def get_first_peer(industry, stage_of_career)
    first_peer =  User.where(live_in_detroit:true, is_participating_this_month: true, waitlist: false, is_assigned_peer_group: false).where("peer_industry = ? AND stage_of_career = ?", industry, stage_of_career).sample
    if first_peer == nil
      first_peer
    else
      first_peer
    end
  end

  def get_other_peers(first_peer)
    stage_of_career = first_peer.stage_of_career
    min = stage_of_career > 1 ? (stage_of_career - 1) : 1
    max = stage_of_career < 5 ? (stage_of_career + 1) : 5
    industry = first_peer.peer_industry
    interests = first_peer.top_3_interests.sample
    current_goal = first_peer.current_goal
    group = User.where(live_in_detroit:true, is_participating_next_month: true, waitlist: false, is_assigned_peer_group: false, peer_industry: industry, current_goal:current_goal).where("stage_of_career >= ? AND stage_of_career <= ? AND ? = ANY(top_3_interests)", min, max, interests)
    if group.length < 2
      return false
    else
      return group.sample(2)
    end
  end

end
