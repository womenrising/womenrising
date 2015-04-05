require 'rails_helper'

RSpec.describe User, :type => :model do
  it{should have_many(:mentees).class_name('Mentor').with_foreign_key('mentee_id')}
  it{should have_many(:mentors).class_name('Mentor').with_foreign_key('mentor_id')}
  it{should have_many(:peer1).class_name('Peer').with_foreign_key('peer1_id')}
  it{should have_many(:peer2).class_name('Peer').with_foreign_key('peer2_id')}
  it{should have_many(:peer3).class_name('Peer').with_foreign_key('peer3_id')}
  it{should have_many(:peer4).class_name('Peer').with_foreign_key('peer4_id')}

  context "#update_month" do
  	it "should update the users is_participating_this_month, is_participating_next_month, mentor_times, is_assigned_peer_group " do
  		current_user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
  		User.update_month
  		current_user = User.find(current_user.id)
  		expect(current_user.is_participating_next_month).to eq(false)
  		expect(current_user.mentor_times).to eq(1)
  		expect(current_user.is_participating_this_month).to eq(true)
  		expect(current_user.is_participating_next_month).to eq(false)
  		expect(current_user.is_assigned_peer_group).to eq(true)
  	end
  end

  context "#check_industry" do
  	it "should be false if everything is put in right" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
  		expect(user.waitlist).to eq(true)
  	end
  end
end
