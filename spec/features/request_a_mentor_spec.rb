require 'rails_helper'

feature 'User can request a mentor' do
  let(:user) { create :user, :not_on_waitlist }

  scenario 'a logged in user user can submit a question and request a mentor and is put on a waitlist', skip: true do
    login_as(user, :scope => :user)
    visit user_path(user)

    click_on("Request a Mentor")
    expect(page).to have_content "What would you like to talk with your mentor about?"
    fill_in 'mentorship[question]', with: 'This is a question'
    expect{click_on 'Submit'}.to change{Mentorship.count}.by(1)
    expect(page).to have_content 'Your request for a mentor has been submitted.'
  end
end
