class AddZipCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :integer
  end
end
