class AddIsParticipatingThisMonthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_participating_this_month, :boolean
  end
end
