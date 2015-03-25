class AddMentorLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor_limit, :integer
  end
end
