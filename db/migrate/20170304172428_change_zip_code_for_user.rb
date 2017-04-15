class ChangeZipCodeForUser < ActiveRecord::Migration
  def up
    change_column :users, :zip_code, :string, limit: 10
  end

  def down
    change_column :users, :zip_code, 'integer USING CAST(zip_code AS integer)'
  end
end
