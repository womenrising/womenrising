class Peer < ActiveRecord::Base
  belongs_to :peer1, class_name: "User", foreign_key: 'peer1_id'
  belongs_to :peer2, class_name: "User", foreign_key: 'peer2_id'
  belongs_to :peer3, class_name: "User", foreign_key: 'peer3_id'


  def get_all_peers
    @all_avalible = User.where(live_in_detroit:true, is_participating_next_month: true, waitlist: false, is_assigned_peer_group: false)
  end

  def choose_first_peer
    @first_peer = get_all_peers.sample
  end

  def get_ther_peers
    min = @first_peer.stage_of_career > 1 ? (@first_peer.stage_of_career - 1) : 1
    max = @first_peer.stage_of_career < 5 ? (@first_peer.stage_of_career + 1) : 5

    @peers = User.where(live_in_detroit:true, is_participating_next_month: true, waitlist: false, is_assigned_peer_group: false, peer_industry: @first_peer.peer_industry).where('stage_of_career >= ? AND stage_of_career <= ?', min, max)
    end
end
