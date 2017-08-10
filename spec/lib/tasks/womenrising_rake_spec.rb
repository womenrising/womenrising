require "rails_helper"

describe "womenrising:mentor_matches" do
  include_context "rake"

  let!(:mentors) { create_list :mentor_user, 3, stage_of_career: 5, mentor_industry: "Technology" }
  let!(:mentorships) { create_list :mentorship, 3 }

  it "matches available mentors with available mentorships" do
    subject.invoke

    mentorships.each do |mentorship|
      mentorship.reload
      expect(mentorship.mentor_id).to_not be_nil
    end
  end

  it 'does not match mentors without available mentor_times' do
    unavailable_mentor = mentors.first
    unavailable_mentor.update(mentor_times: 0)

    expect{ subject.invoke }.to change{ Mentorship.where(mentor_id: nil).count }.by(-2)
  end

  it 'does not change mentorships that already have a mentor' do
    completed_mentorship = mentorships.first
    completed_mentorship.update(mentor: mentors.first)

    expect{ subject.invoke }.to change{ Mentorship.where(mentor_id: nil).count }.by(-2)
  end
end
