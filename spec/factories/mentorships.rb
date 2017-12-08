FactoryBot.define do
  factory :mentorship do
    mentee
    question "Hello?"

    trait :with_mentor do
      mentor
    end
  end
end
