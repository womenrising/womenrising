require 'rails_helper'

RSpec.describe MentorIndustryUser, :type => :model do
  let(:mentor_industry_user) { create(:mentor_industry_user)}
  it "has two IDs and an enum" do
    expect(mentor_industry_user.mentor_industry_id).to eq(5)
    expect(mentor_industry_user.user_id).to eq(6)
    expect(mentor_industry_user.career_stage).to eq("Gaining a foothold")
  end
end
