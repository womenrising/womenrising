class AddMentorIndustryStageOfCareerWaitlistQuestionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentor, :boolean, default:false
    add_column :users, :primary_industry, :string
    add_column :users, :stage_of_career, :integer
    add_column :users, :mentor_industry, :string
    add_column :users, :peer_industry, :string
    add_column :users, :current_goal, :string
    add_column :users, :top_3_interests, :text, array:true, default: []
    add_column :users, :live_in_detroit, :boolean, default:true
    add_column :users, :waitlist, :boolean, default:false
    add_column :users, :is_participating_next_month, :boolean, default:false
  end
end
