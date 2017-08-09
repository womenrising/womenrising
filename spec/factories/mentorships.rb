FactoryGirl.define do
  factory :mentorship do
    mentee_id { FactoryGirl.create(:user, :mentee, :not_on_waitlist).id }
    question "Hello?"
  end
end
