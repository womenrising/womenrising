require 'rails_helper'

RSpec.describe Mentor, :type => :model do
 	it{should belong_to(:mentee).class_name('User').with_foreign_key('mentee_id')}
 	it{should belong_to(:mentoring).class_name('User').with_foreign_key('mentor_id')}
 	before{100.times{FactoryGirl.create(:user)}}

 	it "can get users" do
	    FactoryGirl.create(:user).should be_valid
  	end

 	context "#choose_mentor" do
 		
 		it "Should choose a valid person to mentor" do
 			create = User.create!(email: "hellowerqerwred2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 1)
 			mentee = User.create!(email: "hellowerq2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 1, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 1)
 			mentor_session = Mentor.create(mentee_id: mentee.id, question: "Hello?")
 			mentor = mentor_session.mentoring
 			expect(mentor_session).to be_an_instance_of(Mentor)
 			expect(mentor).to be_an_instance_of(User)
 			expect(mentor.stage_of_career).to be(create.stage_of_career)
 			expect(mentor.mentor_industry).to eq(create.mentor_industry)
 			expect(mentor.waitlist).to be(false)
      expect(mentor.mentor_times).to eq(create.mentor_times-1)
 		end

 		it "Should give a mentor of 5 if the user is 5 and is not themselves" do
 			user = User.create!(email: "hello324q234q3242@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 1)
 			user2 = User.create!(email: "helloweaeawerwrrd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 2)
 			mentee = User.create!(email: "hellowerqed2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 3, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 2)
 			mentor_session = Mentor.create(mentee_id: user.id, question: "Hello?")
 			mentor = mentor_session.mentoring
 			expect(mentor_session).to be_an_instance_of(Mentor)
 			expect(mentor).to be_an_instance_of(User)
 			expect(mentor).to eq(user2)
 			expect(mentor_session).to be_valid
 		end

 		it "Should return error if invaid user" do
 			mentee = User.create!(email: "howerqed2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 3, mentor_industry: "Technology", current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 1)
 			expect(mentee.waitlist).to be(true)
 			expect(Mentor.create(mentee_id: mentee.id, question: "Hello")).to_not be_valid
 		end
 	end

end
