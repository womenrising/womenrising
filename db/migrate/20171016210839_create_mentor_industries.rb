class CreateMentorIndustries < ActiveRecord::Migration
  def change
    create_table :mentor_industries do |t|
      t.string :name

      t.timestamps
    end
  end
end
