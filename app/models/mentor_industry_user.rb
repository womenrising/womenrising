# == Schema Information
#
# Table name: mentor_industry_users
#
#  id                 :integer          not null, primary key
#  mentor_industry_id :integer
#  user_id            :integer
#  career_stage       :integer
#

class MentorIndustryUser < ActiveRecord::Base
  belongs_to :mentor_industry
  belongs_to :user

  enum career_stage: {
    'Intern/Apprentice/Aspiring' => 1,
    'Gaining a foothold' => 2,
    'Management / Senior' => 3,
    'Director/VP/Chief Architect' => 4,
    'C-Level/Founder' => 5
  }

  delegate :name, to: :mentor_industry, allow_nil: true
end
