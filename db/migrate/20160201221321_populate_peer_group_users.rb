class PopulatePeerGroupUsers < ActiveRecord::Migration
  def change
    Peer.all.each do |p|
      PeerGroupUser.create(peer_group_id: p.id, user_id: p.peer1_id) if p.peer1_id
      PeerGroupUser.create(peer_group_id: p.id, user_id: p.peer2_id) if p.peer2_id
      PeerGroupUser.create(peer_group_id: p.id, user_id: p.peer3_id) if p.peer3_id
      PeerGroupUser.create(peer_group_id: p.id, user_id: p.peer4_id) if p.peer4_id
    end
  end
end
