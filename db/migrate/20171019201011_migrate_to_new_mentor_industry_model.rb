class MigrateToNewMentorIndustryModel < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.mentor == true
        if user.mentor_industry == 'Business'
          MentorIndustryUser.create(mentor_industry_id: 1, user_id: user.id, career_stage: user.stage_of_career)
        elsif user.mentor_industry == 'Technology'
          MentorIndustryUser.create(mentor_industry_id: 2, user_id: user.id, career_stage: user.stage_of_career)
        elsif user.mentor_industry == 'Startup'
          MentorIndustryUser.create(mentor_industry_id: 3, user_id: user.id, career_stage: user.stage_of_career)
        end
      end
    end
  end
end
