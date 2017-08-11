require 'rails_helper'

RSpec.describe Mentorship, :type => :model do
   it{should belong_to(:mentee).class_name('User').with_foreign_key('mentee_id')}
   it{should belong_to(:mentor).class_name('User').with_foreign_key('mentor_id')}
   before{100.times{FactoryGirl.create(:user)}}

  it "can get users" do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  context "#choose_mentor" do
    it "Should choose a valid person to mentor" do
      user = create :mentor
      mentee = create :mentee

      mentor_session = Mentorship.create(mentee_id: mentee.id, question: "Hello?")
      mentor = mentor_session.choose_mentor

      expect(mentor_session).to be_an_instance_of(Mentorship)
      expect(mentor).to be_an_instance_of(User)
      expect(mentor.stage_of_career).to be(user.stage_of_career)
      expect(mentor.mentor_industry).to eq(user.mentor_industry)
      expect(mentor.waitlist).to be(false)
    end

    it "Should give a mentor of 5 if the user is 5 and is not themselves" do
      user = create :mentor, stage_of_career: 3
      user2 = create :mentor, stage_of_career: 5
      mentee = create :mentee, stage_of_career: 5

      mentor_session = Mentorship.create(mentee_id: mentee.id, question: "Hello?")
      mentor = mentor_session.choose_mentor

      expect(mentor_session).to be_an_instance_of(Mentorship)
      expect(mentor).to be_an_instance_of(User)
      expect(mentor).to eq(user2)
      expect(mentor_session).to be_valid
    end

    it "Should return error if invaid user" do
      mentee = create :mentee, peer_industry: nil

      expect(mentee.waitlist).to be(true)
      expect(Mentorship.create(mentee_id: mentee.id, question: "Hello")).to_not be_valid
    end
  end
end
