require 'rails_helper'

feature 'User can request a mentor' do
  let(:user) { create :user, :not_on_waitlist }
  let(:question) { 'This is a question' }
  let(:mentor) { create :mentor }
  let!(:mentorship) { create :mentorship, created_at: 1.day.ago, mentor_id: mentor.id, mentee_id: user.id }

  before do
    login_as(user, :scope => :user)
    visit user_path(user)

    click_on('Request a Mentor')
    fill_in 'mentorship[question]', with: question

    click_on 'Submit'
  end

  scenario 'a logged in user user can submit a question and request a mentor and is put on a waitlist' do
    expect(Mentorship.count).to eq(2)
    expect(page).to have_content 'Your request for a mentor has been submitted.'
  end

  scenario 'shows that the request is pending' do
    expect(page). to have_content "Your Mentors"
    expect(page). to have_content question
    expect(page). to have_content "Pending"
  end

  scenario 'mentee can view mentors profile' do
    click_on mentor.full_name
    expect(current_path).to eq user_path(mentor)
    expect(page).to_not have_content "Your"
  end

  scenario 'mentor can view mentees profile' do
    logout
    login_as(mentor, :scope => :user)
    visit user_path(mentor)

    expect(page).to_not have_content "Your Mentors"
    expect(page).to have_content "Your Mentees"
    click_on user.full_name
    expect(current_path).to eq user_path(user)
    expect(page).to_not have_content "Your"
  end

  scenario 'mentee can cancel pending request' do
    expect(page).to have_content "Pending"
    expect(page).to have_content "Cancel"
    expect{ click_on "Cancel" }.to change{Mentorship.count}.by(-1)

    expect(page).to have_content "Your question has been cancelled"
    expect(page).to have_content "Will you participate"
  end

  context 'with multiple mentors' do
    let!(:mentorships) { create_list :mentorship, 5, created_at: 2.days.ago, mentor_id: mentor.id, mentee_id: user.id }
    let!(:old_mentorship) { create :mentorship, created_at: 1.week.ago, mentor_id: mentor.id, mentee_id: user.id, question: 'This is the old question' }
    let!(:new_mentorship) { create :mentorship, created_at: 1.minute.ago, mentor_id: mentor.id, mentee_id: user.id, question: 'This is the new question' }

    scenario 'only shows 3 mentors' do
      visit user_path(user)

      within '.mentor-list' do
        expect(page).to have_css 'li', count: 3
        expect(page).to_not have_content 'This is the old question'
        expect(page).to have_content 'This is the new question'
      end
    end
  end
end
