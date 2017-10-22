require 'rails_helper'

RSpec.describe MentorIndustry, :type => :model do
  let(:mentor_industry) { create(:mentor_industry, name: "Business")}
  it "has a name" do
    expect(mentor_industry.name).to eq("Business")
  end
end
