require 'rails_helper'

RSpec.describe User, :type => :model do
  it{should have_many(:mentees).class_name('Mentor').with_foreign_key('mentee_id')}
  it{should have_many(:mentors).class_name('Mentor').with_foreign_key('mentor_id')}
  it{should have_many(:peer1).class_name('Peer').with_foreign_key('peer1_id')}
  it{should have_many(:peer2).class_name('Peer').with_foreign_key('peer2_id')}
  it{should have_many(:peer3).class_name('Peer').with_foreign_key('peer3_id')}
  it{should have_many(:peer4).class_name('Peer').with_foreign_key('peer4_id')}
  it{should validate_presence_of(:first_name)}
  it{should validate_presence_of(:last_name)}

  before{10.times{FactoryGirl.create(:user)}}
  context "#update_month" do
  	it "should update the users is_participating_this_month, mentor_times, is_assigned_peer_group if the user is paricipating this month" do
  		current_user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: true,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
  		User.update_month
  		current_user = User.find(current_user.id)
  		expect(current_user.mentor_times).to eq(1)
  		expect(current_user.is_participating_this_month).to eq(false)
  		expect(current_user.is_assigned_peer_group).to eq(false)
  	end

  	it "should update the user if the user is not participating this month and they have mentor_times" do
  		current_user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 2, mentor_limit: 1, is_assigned_peer_group: false)
  		User.update_month
  		current_user = User.find(current_user.id)
  		expect(current_user.mentor_times).to eq(0)
  		expect(current_user.is_participating_this_month).to eq(false)
  		expect(current_user.is_assigned_peer_group).to eq(false)
  	end

  end

  context "#check_industry" do
  	it "should be true if no current goal" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
  		expect(user.waitlist).to eq(true)
  	end

  	it "should be false if everything is put in right" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: ["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
  		expect(user.waitlist).to eq(false)
  	end

  	it "should be true if primary industry is nil" do
  		user = User.where(waitlist: false).sample
  		user.update(primary_industry:nil)
  		expect(user.waitlist).to eq(true)
  	end

  	it "should be true if primary industry is Other" do
  		user = User.where(waitlist: false).sample
  		user.update(primary_industry:"Other")
  		expect(user.waitlist).to eq(true)
  	end

  	it "should be true if top_3_interests is []" do
  		user = User.where(waitlist: false).sample
  		user.update(top_3_interests: [])
  		expect(user.waitlist).to eq(true)
  	end
  end

  context ".mentor_times_change" do
    it "should 0 if the change makes it negative" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
      expect(user.mentor_times_change(0)).to eq(0)
    end

    it "should return higher but not the full limit if the change is greater than the limit but one of the mentor times is gone" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 0, mentor_limit: 1, is_assigned_peer_group: true)
      expect(user.mentor_times_change(4)).to eq(3)
    end

    it "should return higher if the change is greater than the limit" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 1, mentor_limit: 1, is_assigned_peer_group: true)
      expect(user.mentor_times_change(4)).to eq(4)
    end

    it "should return lower if there is still mentor times" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 3, mentor_limit: 3, is_assigned_peer_group: true)
      expect(user.mentor_times_change(2)).to eq(2)
    end

    it "should return the same amount if nothing changes" do
  		user = User.create!(email: "hellowerd2@gmail.com", password: "Somethingwierd12",password_confirmation: "Somethingwierd12", first_name: "Hello",last_name: "world", mentor: true, primary_industry: "Technology", stage_of_career: 5, mentor_industry: "Technology", peer_industry: ["Business", "Technology", "Startup"].sample, current_goal: nil,top_3_interests: ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3), live_in_detroit: %w(true false).sample, is_participating_next_month: true, is_participating_this_month: false,
 				mentor_times: 2, mentor_limit: 3, is_assigned_peer_group: true)
      expect(user.mentor_times_change(3)).to eq(2)
    end

  end
    
end
