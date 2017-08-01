class RemoveLiveInDetroitFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :live_in_detroit, :boolean
  end
end
