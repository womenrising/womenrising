class PeerGroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :peer_group
end
