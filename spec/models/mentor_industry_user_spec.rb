require 'rails_helper'
RSpec.describe MentorIndustryUser do
  let(:mentor_industry_user) { create(:mentor_industry_user)}
  it "has a mentor_industry_id, a user_id, and a career_stage enum" do
    expect(mentor_industry_user.mentor_industry_id).to eq(5)
    expect(mentor_industry_user.user_id).to eq(6)
    expect(mentor_industry_user.career_stage).to eq("Gaining a foothold")
  end
end
