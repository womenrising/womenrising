# == Schema Information
#
# Table name: peer_groups
#
#  id         :integer          not null, primary key
#  peer1_id   :integer
#  peer2_id   :integer
#  peer3_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  peer4_id   :integer
#

class PeerGroup < ActiveRecord::Base
  has_many :peer_group_users
  has_many :users, through: :peer_group_users

  def send_mail
    users.each do |user|
      action = :peer_group_send_mail
      message = "User # #{user.id}"
      SlackNotification.notify(action, message)
    end

    UserMailer.peer_mail(self).deliver
  end

  def self.generate_groups
    users = User.where(
      is_participating_this_month: true,
      waitlist: false,
      live_in_detroit: true,
      is_assigned_peer_group: false
    )

    groups = organize_into_groups!(users)

    groups.each do |group|
      update_users!(group)
      peer_group = PeerGroup.new

      group.each { |user| peer_group.users << user }

      peer_group.save
      peer_group.send_mail
    end
  end

  def self.organize_into_groups!(users)
    quotient, remainder = users.length.divmod(3)
    number_of_groups = remainder > 1 ? quotient + 1 : quotient

    Array.new(number_of_groups) do
      sample_size = users.length == 4 ? 4 : 3
      selected = users.sample(sample_size)
      users -= selected

      selected
    end
  end

  def self.update_users!(group)
    group.each { |user| user.update(is_assigned_peer_group: true) }
  end

  def self.get_peers(industry, stage_of_career)
    User.where(
      is_participating_this_month: true,
      waitlist: false,
      live_in_detroit: true,
      is_assigned_peer_group: false,
      peer_industry: industry,
      stage_of_career: stage_of_career
    )
  end

  def self.get_one_peer(group)
    group.sample
  end

  def self.remove_peer(group, peer)
    group - [peer]
  end

  def self.check_interests(group, peer)
    group_interests = get_group_interests(group)
    (peer.top_3_interests - group_interests).length < 3
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
    peer.current_goal == group[0].current_goal && check_interests(group, peer)
  end

  def self.assign_group(peer_groups, peer)
    peer_groups.each do |group|
      if check_group(group, peer) && group.length < 3
        group << peer
        return peer_groups
      end
    end
    peer_groups << [peer]
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
      peer_groups = assign_group_no_common_current_goal(group, current_peer)
    end
    peer_groups
  end

  def self.get_not_full_groups(all_peer_groups)
    groups = all_peer_groups
    peer_groups = []
    groups.each do |group|
      peer_groups << group if group.length < 3
    end
    peer_groups
  end

  def self.assign_group_no_common_current_goal(peer_groups, peer)
    peer_groups.each do |group|
      if check_interests(group, peer) && group.length < 3
        group << peer
        return peer_groups
      end
    end
    peer_groups << [peer]
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
