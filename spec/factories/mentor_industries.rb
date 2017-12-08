FactoryBot.define do
  factory :mentor_industry, class: MentorIndustry do
    trait :business do
      name "Business"
    end

    trait :startup do
      name "Startup"
    end

    trait :technology do
      name "Technology"
    end
  end
end
