class AddMentorTimesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor_times, :integer, default: 1
  end
end
