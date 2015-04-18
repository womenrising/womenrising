class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'
  belongs_to :peer4, class_name: "User", foreign_key: 'peer4_id'

  after_save do
    self.send_mail
  end

  def send_mail
    if self.peer4 == nil
      UserMailer.three_peer_mail(self).deliver
    else
      UserMailer.four_peer_mail(self).deliver
    end
  end

  def self.automattially_create_groups
    remainder = []
    ["Technology","Business", "Startup"].each do |industry|
      (1..5).each do |stage_of_career|
        groups = create_groups(industry, stage_of_career, remainder)
        outlyers = get_not_full_groups(groups)
        if outlyers.flatten.length > 0
          groups -= outlyers
          groups = reassign_not_full_groups(groups, outlyers.flatten)
          new_outlyers = get_not_full_groups(groups)
          if stage_of_career == 5 && industry == "Startup" && new_outlyers.flatten.length > 0
            groups = assign_groups_final(groups, new_outlyers.flatten)
          elsif new_outlyers.flatten.length > 0
            remainder = new_outlyers.flatten
            groups -= new_outlyers 
          end
        end
        create_peer_groups(groups)
      end
    end
    
  end

  def self.create_peer_groups(groups)
    groups.each do |group|
      if group.length == 3
        Peer.create!(peer1:group[0],peer2:group[1],peer3:group[2])
      elsif group.length == 4
        Peer.create!(peer1:group[0],peer2:group[1],peer3:group[2],peer4:group[3])
      end
      group.each do |indv|
        indv.update(is_assigned_peer_group: true)
      end
    end
  end

  def self.assign_groups_final(group, outlyers)
    outlyers = outlyers.flatten
    while outlyers.length > 0
      current_peer = get_one_peer(outlyers)
      outlyers = remove_peer(outlyers, current_peer)
      peer_groups = assign_group_no_checks(group, current_peer, 4)
    end
    peer_groups
  end

  def self.assign_group_no_checks(peer_groups, peer, length)
    peer_groups.each do |group|
      if group.length < length
        group << peer
        return peer_groups
      end
    end
  end

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

  def self.reassign_not_full_groups(group, outlyers)
    outlyers = outlyers.flatten
    while outlyers.length > 0
      current_peer = get_one_peer(outlyers)
      outlyers = remove_peer(outlyers, current_peer)
      peer_groups = assign_group(group, current_peer, 4)
    end
    peer_groups
  end

  def self.create_groups(industry, stage_of_career, remainder)
    group = get_peer_group(industry, stage_of_career) + remainder
    peer_groups = []
    while group.length > 0
      current_peer = get_one_peer(group)
      group = remove_peer(group, current_peer)
      peer_groups = assign_group(peer_groups, current_peer, 3)
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

  def self.assign_group(peer_groups, peer, length)
    peer_groups.each do |group|
      if check_group(group, peer) && group.length < length
        group << peer
        return peer_groups
      end
    end
    return peer_groups << [peer]
  end

end
