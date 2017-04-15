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
    Location.all.each do |location|
      groups = automatically_create_groups(location)

      groups.each do |group|
        update_users!(group)
        peer_group = PeerGroup.new

        group.each { |user| peer_group.users << user }

        peer_group.save
        peer_group.send_mail
      end
    end
  end

  def self.automatically_create_groups(location)
    users = User.where(
      is_participating_this_month: true,
      waitlist: false,
      is_assigned_peer_group: false,
      location_id: location.id
    )

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
end
