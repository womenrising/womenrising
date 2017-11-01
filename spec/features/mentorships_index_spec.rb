require 'rails_helper'

feature "I want to see a list of past mentorships", focus: true do
  let(:user) { create :user }

  before do
    login_as(user, :scope => :user)
  end

  scenario "On my profile page, there is a link to my mentorship history" do
    visit user_path(user)

    save_and_open_page
    expect(page).to have_selector(:link_or_button, 'Mentorship History')
  end
end
