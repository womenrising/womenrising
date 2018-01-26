require "rails_helper"

describe "womenrising:peer_group_signup_reminder" do
  include_context "rake"

  let!(:users) { create_list :user, 10, is_participating_this_month: false }

  it 'runs three days before the end of the month' do
    travel_to(DateTime.new(2018,1,28)) do
      subject.invoke
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(10)
    end
  end

  it 'does not run on other days of the month' do
    travel_to(DateTime.new(2018,1,26)) do
      subject.invoke
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(0)
    end
  end
end
