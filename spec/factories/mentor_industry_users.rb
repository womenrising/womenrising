FactoryBot.define do
  factory :mentor_industry_user, class: MentorIndustryUser do
    user
    mentor_industry
    career_stage 5
  end
end
