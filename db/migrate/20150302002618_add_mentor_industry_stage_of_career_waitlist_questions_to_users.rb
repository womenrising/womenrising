class AddMentorIndustryStageOfCareerWaitlistQuestionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor, :boolean, default:false
    add_column :users, :primary_industry, :string
    add_column :users, :secondary_industry, :string
    add_column :users, :tertiary_industry, :string
    add_column :users, :stage_of_career, :string
    add_column :users, :question_1, :text
    add_column :users, :question_2, :text
    add_column :users, :question_3, :text
    add_column :users, :waitlist, :boolean, default:true
  end
end
