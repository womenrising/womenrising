require 'rails_helper'

feature 'peer matches' do
  let(:boulder) { create :location }
  let!(:users) { create_list :user, 7, :groupable, location: boulder }
  let!(:not_participating_user) { create :user, :groupable, location: boulder, is_participating_this_month: false }
  let(:admin_user) { create :admin_user }

  context 'when admin clicks the button' do
    before do
      login_as admin_user, scope: :admin_user
      visit admin_users_path
    end

    scenario 'matches are run and users are reset' do
      click_on 'Run Monthly Matching'

      user = users.sample.reload
      expect(page).to have_content 'Ran Monthly Matches'
      expect(user.current_peer_group).to be_present
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(7)

      users.each { |u| u.reload.update!(is_participating_this_month: true) }
      expect do
        click_on 'Run Monthly Matching'
      end.to change { user.current_peer_group }
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(14)
    end

    scenario 'only matches users that are particiapting' do
      click_on 'Run Monthly Matching'
      expect(not_participating_user.reload.current_peer_group).to be_nil
    end

    scenario 'sends email and Slack notifications' do
      expect(SlackNotification).to receive(:notify).exactly(4).times
      click_on 'Run Monthly Matching'
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(7)
    end
  end
end
