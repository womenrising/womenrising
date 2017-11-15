require 'rails_helper'
RSpec.describe MentorIndustry do
  let(:mentor_industry) { create(:mentor_industry, :business)}
  it "has a name" do
    expect(mentor_industry.name).to eq("Business")
  end
end
