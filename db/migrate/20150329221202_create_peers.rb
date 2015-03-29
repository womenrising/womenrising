class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.integer :peer1_id
      t.integer :peer2_id
      t.integer :peer3_id

      t.timestamps
    end
  end
end
