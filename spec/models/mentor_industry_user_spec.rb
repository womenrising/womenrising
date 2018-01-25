require 'rails_helper'
RSpec.describe MentorIndustryUser do
  let(:user) { create(:user)}
  let(:mentor_industry) { create(:mentor_industry, :technology)}
  let!(:mentor_industry_user) { create(:mentor_industry_user, user: user, mentor_industry: mentor_industry)}

  it 'has a mentor_industry_id, a user_id, and a career_stage enum' do
    expect(mentor_industry_user.user_id).to eq(user.id)
    expect(mentor_industry_user.mentor_industry_id).to eq(mentor_industry.id)
    expect(mentor_industry_user.career_stage).to eq('C-Level/Founder')
  end
end
