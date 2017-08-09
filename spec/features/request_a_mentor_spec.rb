require 'rails_helper'

feature 'User can request a mentor' do
  let(:mentee) { create :user, :not_on_waitlist }

  scenario 'a logged in user user can submit a question and request a mentor and is put on a waitlist' do
    login_as(mentee, :scope => :user)
    visit user_path(mentee)

    click_on("Request a Mentor")
    expect(page).to have_content "What would you like to talk with your mentor about?"
    fill_in 'mentorship_question', with: 'This is a question'
    expect{click_on 'Submit'}.to change{Mentorship.count}.by(1)
    expect(page).to have_content 'Your request for a mentor has been submitted.'
  end

  context 'when the rake task is run (daily)' do
    let!(:mentors) { create_list :mentor_user, 3 }
    let!(:mentorships) { create_list :mentorship, 3 }

    scenario'if a mentor is avaiable, mentee is matched' do
      # run the rake task
      expect(mentorships.first.mentor_id).to_not be_nil
      expect(mentor.mentor_times).to eq 0

      # expect email to be sent
    end

    xscenario 'if a mentor is unavaiable, mentee is placed on a waitlist' do
      # As a mentee when requesting a mentor, if none are available, you should get a notice that you have been put on a waitlist/queue for mentors. The next time a mentor becomes available, it should automatically match the mentor with the next mentee on the queue.
    end

    xscenario 'mentees should get matched in order of time of request' do
      # A mentee who submitted questions first should get matches before later questions
    end
  end
end
