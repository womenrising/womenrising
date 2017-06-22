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

  scope :current, -> { where('peer_groups.created_at > ?', 40.days.ago).order(created_at: :desc) }

  def self.generate_groups
    Location.all.each do |location|
      groups = automatically_create_groups(location)

      groups.each do |grouped_users|
        peer_group = PeerGroup.new
        grouped_users.each do |user|
          peer_group.users << user
          user.update is_participating_this_month: false
        end

        peer_group.save
        peer_group.send_mail
      end
    end
  end

  def self.automatically_create_groups location
    users = User.where is_participating_this_month: true, location: location

    quotient, remainder = users.length.divmod(3)
    number_of_groups = remainder > 1 ? quotient + 1 : quotient

    number_of_groups.times.collect do
      group_size = users.length == 4 ? 4 : 3
      users.sample(group_size).tap do |selected|
        users -= selected
      end
    end
  end

  def send_mail
    SlackNotification.notify(:peer_group_send_mail, "Users ##{users.map(&:id).join(", #")}")
    UserMailer.peer_mail(self).deliver
  end
end
