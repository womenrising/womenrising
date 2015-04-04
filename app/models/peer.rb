class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'
  belongs_to :peer4, class_name: "User", foreign_key: 'peer4_id'

  def self.get_peer_group(industry, stage_of_career)
    User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: industry, stage_of_career: stage_of_career)
  end

  def self.get_not_full_groups(all_peer_groups)
    groups = all_peer_groups
    peer_groups = []
    groups.each do |group|
      if group.length < 3
        peer_groups << group
      end
    end
    peer_groups
  end

  # def self.reassign_not_full_groups(industry, stage_of_career)
    
  #   if 
  # end

  def self.create_groups(industry, stage_of_career)
    group = get_peer_group(industry, stage_of_career)
    peer_groups = []
    while group.length > 0
      current_peer = get_one_peer(group)
      group = remove_peer(group, current_peer)
      peer_groups = assign_group(peer_groups, current_peer)
    end
    peer_groups
  end

  def self.get_one_peer(group)
    group.sample
  end

  def self.remove_peer(group, peer)
    group - [peer]
  end

  def self.check_group(group, peer)
    return peer.current_goal == group[0].current_goal && check_interests(group, peer)
  end

  def self.check_interests(group, peer)
    group_interests = get_group_interests(group)
    return (peer.top_3_interests - group_interests).length < 3
  end

  def self.get_group_interests(group)
    group_interests = []
    group.each do |peer|
      if group_interests.empty?
        group_interests = peer.top_3_interests
      else
        differing_interest = group_interests - peer.top_3_interests
        group_interests -= differing_interest
      end
    end
    group_interests
  end

  def self.assign_group(peer_groups, peer)
    peer_groups.each do |group|
      if check_group(group, peer) && group.length < 3
        group << peer
        return peer_groups
      end
    end
    return peer_groups << [peer]
  end

end
