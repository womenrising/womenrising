# == Schema Information
#
# Table name: peer_group_users
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  peer_group_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class PeerGroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :peer_group
end
