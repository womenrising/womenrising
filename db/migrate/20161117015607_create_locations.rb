class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city
    end
  end
end
