class RenamePeerToPeerGroup < ActiveRecord::Migration
  def change
    rename_table :peers, :peer_groups
  end
end
