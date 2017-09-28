class AddCompletedFlagsToMentorships < ActiveRecord::Migration
  def change
    add_column :mentorships, :mentor_completed, :boolean, default: false
    add_column :mentorships, :mentee_completed, :boolean, default: false
  end
end
