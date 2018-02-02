class PopulatePeerGroupUsers < ActiveRecord::Migration
  def up
    #
    # we need to use raw SQL because we want to run the migration even if the
    # Rails ActiveRecord model class (ie, Peer) is not defined.
    #
    sql = 'SELECT id, peer1_id, peer2_id, peer3_id, peer4_id FROM peers'
    results = ActiveRecord::Base.connection.execute(sql)

    results.to_a.each do |result|
      PeerGroupUser.create(peer_group_id: result['id'], user_id: result['peer1_id']) if result['peer1_id']
      PeerGroupUser.create(peer_group_id: result['id'], user_id: result['peer2_id']) if result['peer2_id']
      PeerGroupUser.create(peer_group_id: result['id'], user_id: result['peer3_id']) if result['peer3_id']
      PeerGroupUser.create(peer_group_id: result['id'], user_id: result['peer4_id']) if result['peer4_id']
    end
  end

  def down
  end
end
