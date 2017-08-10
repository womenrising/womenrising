FactoryGirl.define do
  factory :mentorship do
    mentee_id { FactoryGirl.create(:user, :mentee, :not_on_waitlist, :any_stage_of_career, primary_industry: "Technology").id }
    question "Hello?"
  end
end
