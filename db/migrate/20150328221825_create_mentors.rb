class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.integer :mentor_id
      t.integer :mentee_id

      t.timestamps
    end
  end
end
