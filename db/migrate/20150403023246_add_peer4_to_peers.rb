class AddPeer4ToPeers < ActiveRecord::Migration
  def change
    add_column :peers, :peer4_id, :integer
  end
end
