require 'rails_helper'

describe 'user show page' do
  let!(:location) { create :location }
  let!(:user) { create :active_user, location: location }
  let!(:other_user) { create :active_user, location: location }

  before do
    login_as(user, scope: :user)
  end

  it 'should be viewable by other users' do
    visit user_path(other_user)
    expect(page).to have_content other_user.full_name
  end

  it 'should show other users in peer group' do
    PeerGroup.generate_groups
    visit user_path(user)
    expect(page).to have_content other_user.full_name
  end
end
