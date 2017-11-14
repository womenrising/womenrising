require "rails_helper"

describe "womenrising:mentor_matches" do
  include_context "rake"

  context 'with multiple mentors and mentorships' do
    let!(:mentee) { create :mentee, :new_to_technology }
    # let!(:mentors) { create_list :mentors, 3 }
    let!(:mentorships) { create_list :mentorship, 3 }

    let!(:senior_tech_mentor) { create :mentor, :senior_tech_mentor }
    let!(:founder_tech_mentor) { create :mentor, :founder_tech_mentor }

    it "matches available mentors with available mentorships" do
      subject.invoke

      mentorships.each do |mentorship|
        mentorship.reload
        expect(mentorship.mentor_id).to_not be_nil
        expect(mentorship.mentor.mentor_times).to eq 0
      end
    end

    it 'does not match mentors without available mentor_times' do
      unavailable_mentor = senior_tech_mentor
      unavailable_mentor.update(mentor_times: 0)

      expect{ subject.invoke }.to change{ Mentorship.where(mentor_id: nil).count }.by(-2)
    end

    it 'does not change mentorships that already have a mentor' do
      completed_mentorship = mentorships.first
      completed_mentorship.update(mentor: senior_tech_mentor)

      expect{ subject.invoke }.to change{ Mentorship.where(mentor_id: nil).count }.by(-2)
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(4)
    end

    it 'does not change mentor times if a mentor was not matched' do
      extra_mentor = create :mentor

      subject.invoke

      expect(extra_mentor.mentor_times).to eq 1
    end

    it 'sends an email when mentors are matched' do
      subject.invoke

      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(6)
    end
  end

  it 'matches mentees in order of time of request' do
    later_mentorships = create_list :mentorship, 10
    first_mentorship = create :mentorship, created_at: 1.week.ago
    mentor = create :mentor

    subject.invoke

    expect(first_mentorship.reload.mentor_id).to eq(mentor.id)
  end
end
