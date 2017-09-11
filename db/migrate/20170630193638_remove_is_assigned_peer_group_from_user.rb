class RemoveIsAssignedPeerGroupFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :is_assigned_peer_group
  end
end
