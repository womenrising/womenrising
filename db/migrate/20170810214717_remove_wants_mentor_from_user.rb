class RemoveWantsMentorFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :wants_mentor, :boolean
  end
end
