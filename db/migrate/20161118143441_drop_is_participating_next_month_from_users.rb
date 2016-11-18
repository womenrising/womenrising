class DropIsParticipatingNextMonthFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_participating_next_month
  end
end
