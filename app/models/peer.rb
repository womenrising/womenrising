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

  def self.generate_groups
    groups = automatially_create_groups
    create_peer_groups(groups)
    get_remainder = User.where(is_participating_this_month:true, waitlist: false, live_in_detroit: true, is_assigned_peer_group:false)
    remainder_groups = []
    if get_remainder != []
      while get_remainder.length > 2
        new_group = get_remainder.sample(3)
        get_remainder -= new_group
        remainder_groups << new_group
      end
      get_remainder.each do |indv|
        indv.update(is_assigned_peer_group:true)
        UserMailer.peer_unavailable_mail(indv).deliver
      end
      create_peer_groups(remainder_groups)
    end
    groups += remainder_groups
  end

  def self.automatially_create_groups
    all_groups = []
    ["Technology","Business", "Startup"].each do |industry|
      remainder = []
      industry_groups = []
      (1..5).each do |stage_of_career|
        groups = create_groups(remainder, industry, stage_of_career)
        outlyers = get_singles(groups)
        groups -= outlyers
        if outlyers.length > 0
          groups = reassign_not_full_groups(groups, outlyers.flatten)
          new_outlyers = get_not_full_groups(groups)
          groups -= new_outlyers
          industry_groups += groups
          if stage_of_career == 5
            industry_groups = assign_group_no_checks(industry_groups, new_outlyers.flatten)
          else
            remainder = new_outlyers
          end
        else
          new_outlyers = get_not_full_groups(groups)
          groups -= new_outlyers
          groups = reassign_not_full_groups(groups, new_outlyers.flatten)
          if groups != nil
            new_outlyers = get_not_full_groups(groups)
            groups -= new_outlyers
            industry_groups += groups
            if new_outlyers.length > 0
              industry_groups = assign_group_no_checks(industry_groups, new_outlyers.flatten)
              remainder = []
            end
          end
        end
      end
      all_groups += industry_groups
    end
    all_groups
  end

  def self.get_peers(industry, stage_of_career)
    User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: industry, stage_of_career: stage_of_career)
  end

  def self.get_one_peer(group)
    group.sample
  end

  def self.remove_peer(group, peer)
    group - [peer]
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

  def self.check_group(group, peer)
    return peer.current_goal == group[0].current_goal && check_interests(group, peer)
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

  def self.create_groups(all_groups, industry, stage_of_career)
    group = get_peers(industry, stage_of_career)
    peer_groups = all_groups
    while group.length > 0
      current_peer = get_one_peer(group)
      group = remove_peer(group, current_peer)
      peer_groups = assign_group(peer_groups, current_peer)
    end
    peer_groups
  end

  def self.reassign_not_full_groups(group, outlyers)
    outlyers = outlyers.flatten
    while outlyers.length > 0
      current_peer = get_one_peer(outlyers)
      outlyers = remove_peer(outlyers, current_peer)
      peer_groups = assign_group_no_cg(group, current_peer)
    end
    peer_groups
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

  def self.assign_group_no_cg(peer_groups, peer)
    peer_groups.each do |group|
      if check_interests(group, peer) && group.length < 3
        group << peer
        return peer_groups
      end
    end
    return peer_groups << [peer]
  end

  def self.create_peer_groups(groups)
    # binding.pry
    groups.each do |group|
        update_user(group)
        if group.length == 3
          Peer.create!(peer1:group[0],peer2:group[1],peer3:group[2])
        elsif group.length == 4
          Peer.create!(peer1:group[0],peer2:group[1],peer3:group[2],peer4:group[3])
        end
    end
  end

  def self.update_user(group)
    group.each do |indv|
      indv.update(is_assigned_peer_group: true)
    end
  end

  def self.assign_group_no_checks(peer_groups, peers)
    while peers.length > 0
      if peers.length >= 3
        peer_sample = peers.sample(3)
        peer_groups << peer_sample
        peers -= peer_sample
      else
        peer = get_one_peer(peers)
        peers = remove_peer(peers, peer)
        peer_groups = assign_to_group_of_three(peer_groups, peer)
      end
    end
    peer_groups
  end

  def self.assign_to_group_of_three(peer_groups, peer)
    peer_groups.each do |group|
      if group.length < 4
        group << peer
        return peer_groups
      end
    end
  end

  def self.get_singles(groups)
    singles = []
    groups.each do |group|
      singles << group if group.length == 1
    end
    singles
  end 

end
