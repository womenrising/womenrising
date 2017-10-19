class CreateMentorIndustryUsers < ActiveRecord::Migration
  def change
    create_table :mentor_industry_users do |t|
      t.integer :mentor_industry_id
      t.integer :user_id
      t.integer :career_stage
    end
  end
end
