class RenameMentorsTableToMentorships < ActiveRecord::Migration
  def change
    rename_table :mentors, :mentorships
  end
end
