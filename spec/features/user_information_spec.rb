require 'rails_helper'

feature 'User can edit information', focus: true do
  let!(:user) { create :skinny_user, :not_on_waitlist }

  before do
    login_as(user, :scope => :user)
    visit user_path(user)
  end

  scenario 'after signing up' do
    expect(page).to_not have_content 'Sign_in'
  end
end
