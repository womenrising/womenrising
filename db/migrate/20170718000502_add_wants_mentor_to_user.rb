class AddWantsMentorToUser < ActiveRecord::Migration
  def change
    add_column :users, :wants_mentor, :boolean, default: false
  end
end
