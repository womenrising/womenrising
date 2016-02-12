class CreatePeerGroupUsers < ActiveRecord::Migration
  def change
    create_table :peer_group_users do |t|
      t.integer :user_id
      t.integer :peer_group_id

      t.timestamps
    end
  end
end
