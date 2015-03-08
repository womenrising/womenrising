class AddMentorIndustryStageOfCareerWaitlistQuestionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor, :boolean, default:false
    add_column :users, :primary_industry, :string
    add_column :users, :stage_of_career, :integer
    add_column :users, :mentor_industry, :string
    add_column :users, :peer_industry, :string
    add_column :users, :goal_right_now, :string
    add_column :users, :top_3_interests, :text
    add_column :users, :live_in_detroit, :boolean, default:true
    add_column :users, :waitlist, :boolean, default:true
  end
end
