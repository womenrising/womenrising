require 'rails_helper'

describe 'womenrising:peer_group_monthly_match' do
  include_context 'rake'

  let(:boulder) { create :location }
  let!(:users) { create_list :user, 10, :groupable, location: boulder }
  let!(:mentor) { create :mentor, mentor_limit: 2, mentor_times: 0, is_participating_this_month: true }

  it 'runs on the first day of the month' do
    travel_to(DateTime.new(2017, 8, 1)) do
      expect(User).to receive(:match_peers_and_update_users).and_call_original

      subject.invoke
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(10)
      expect(mentor.reload.mentor_times).to eq(2)
    end
  end

  it 'does not run on other days of the month' do
    travel_to(DateTime.new(20017, 1, 11)) do
      expect(User).to_not receive(:match_peers_and_update_users)

      subject.invoke
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(0)
      expect(mentor.reload.mentor_times).to eq(0)
    end
  end
end
