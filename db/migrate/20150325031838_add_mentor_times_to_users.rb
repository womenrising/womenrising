class AddMentorTimesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor_times, :integer
  end
end
