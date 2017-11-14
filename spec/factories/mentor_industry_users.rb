FactoryGirl.define do
  factory :mentor_industry_user, class: MentorIndustryUser do
    trait :senior_tech_mentor do
      after_create do |industry_user|
        industry_user.mentor_industry = create :mentor_industry, :technology
        industry_user.career_stage = 3
      end
    end

    trait :founder_tech_mentor do
      after_create do |industry_user|
        industry_user.mentor_industry = create :mentor_industry, :technology
        industry_user.career_stage = 5
      end
    end
  end
end
