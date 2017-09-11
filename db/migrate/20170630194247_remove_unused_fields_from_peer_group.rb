class RemoveUnusedFieldsFromPeerGroup < ActiveRecord::Migration
  def change
    remove_column :peer_groups, :peer1_id, :integer
    remove_column :peer_groups, :peer2_id, :integer
    remove_column :peer_groups, :peer3_id, :integer
    remove_column :peer_groups, :peer4_id, :integer
  end
end
