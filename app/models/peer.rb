class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'
  belongs_to :peer4, class_name: "User", foreign_key: 'peer4_id'

  def self.get_peer_group(industry, stage_of_career)
    User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: industry, stage_of_career: stage_of_career)
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


  # def self.create_groups(industry, stage_of_career)
  #   @@completed_group = []
  #   temp_groups = []
  #   group = get_peer_group(industry, stage_of_career)
  #   while group.length > 3
  #     current_peer = get_one_peer
  #     group = remove_peer(group, current_peer)
  #     if @@temp_groups.length == 0
  #       @@temp_groups << [current_peer]
  #     else
  #       @@temp_groups.each do |a_group|
  #         if check_group(a_group, current_peer)
  #           a_group << current_peer
  #           if a_group.length == 3

  #     end
  #   end
  # end

end
