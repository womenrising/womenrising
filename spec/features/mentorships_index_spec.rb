require 'rails_helper'

feature "I want to see a list of past mentorships" do
  let(:user) { create :user, :not_on_waitlist }
  let!(:mentorship1) { create :mentorship, :with_mentor, mentee: user }
  let!(:mentorship2) { create :mentorship, :with_mentor, mentor: user }

  before do
    login_as(user, :scope => :user)
  end

  ACCESS_BUTTON_TEXT = 'Mentorship History'

  scenario "On my profile page, there is a link to my mentorship history" do
    visit user_path(user)

    expect(page).to have_selector(:link_or_button, ACCESS_BUTTON_TEXT)
  end

  scenario "I should have a list of past mentorships" do
    visit user_path(user)

    click_on "Mentorship History"

    within 'tr', text: mentorship1.mentor.full_name do
      expect(page).to have_content mentorship1.mentor.full_name
      expect(page).to have_content user.full_name
      expect(page).to have_content I18n.l(mentorship1.created_at.to_date, format: :default)
      expect(page).to have_content mentorship1.question
    end

    within 'tr', text: mentorship2.mentee.full_name do
      expect(page).to have_content mentorship2.mentee.full_name
      expect(page).to have_content user.full_name
      expect(page).to have_content I18n.l(mentorship2.created_at.to_date, format: :default)
      expect(page).to have_content mentorship2.question
    end
  end

  scenario "I can't see another user's mentorships" do
    another_user = create :user, :not_on_waitlist
    other_mentorship1 = create :mentorship, mentee: another_user, mentor: user
    other_mentorship2 = create :mentorship, :with_mentor, mentor: another_user

    visit user_path(another_user)

    expect(page).not_to have_selector(:link_or_button, ACCESS_BUTTON_TEXT)
  end
end
