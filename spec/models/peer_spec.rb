require 'rails_helper'

describe Peer do
  it { should belong_to(:peer1)}
  it { should belong_to(:peer2)}
  it { should belong_to(:peer3)}
  it { should belong_to(:peer4)}

  it "can get users" do
    FactoryGirl.create(:user).should be_valid
  end
 
  before{100.times{FactoryGirl.create(:user)}}
  it "Should have a database of 300 users" do
    expect(User.all.count).to eq(100)
  end 

  context "#self.get_current_peers" do
    it "should get a group of peers for the industry and stage of career passed in" do
      group = Peer.get_peers("Technology",1)
      expect(group).not_to be_empty 
    end
  end

  context "#self.get_one_peer" do
    it "should get a single " do
      peer = Peer.get_one_peer(Peer.get_peers("Technology",1))
      expect(peer).to be_an_instance_of(User)
    end
  end

  context "#self.remove_peer(group, peer)" do
    it "should get a single " do
      group = Peer.get_peers("Technology",1)
      peer = Peer.get_one_peer(group)
      expect(Peer.remove_peer(group, peer).count).to eq(group.length - 1)
       expect(Peer.remove_peer(group, peer).include?(peer)).to eq(false)
    end
  end

  context "#check_interests" do
    it "Should return false if there isn't a same common interest" do
      group = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, top_3_interests: ["Anime", "Animals","Fruit"])
      expect(Peer.check_interests(group, peer)).to eq(false)
    end

    it "Should return true if there is a same common interest" do
      group = User.where("? = ANY(top_3_interests)", "Cats").sample(3)
      peer = group.pop
      expect(Peer.check_interests(group, peer)).to eq(true)
    end
  end

  context "#get_group_interests" do
    it "should return an array of common interests" do
      group1_1 = User.create(email: "hello2@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_3 = User.create(email: "hello4@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Bats", "Cats","Beer"])
      group = [group1_1, group1_3]
      expect(Peer.get_group_interests(group)).not_to be_empty
      expect(Peer.get_group_interests(group)).to eq(["Cats","Bats"])
     end
  end

  context "#check_group" do
    it "should return true if valid" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group = [group1_1, group1_2]
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      expect(Peer.check_group(group, peer)).to eq(true)
    end

    it "should return false if they don't have the same current_goal" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group = [group1_1, group1_2]
       peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Switching Industries", top_3_interests: ["Anime", "Cats","Fruit"])
      expect(Peer.check_group(group, peer)).to be(false)
    end

    it "should return false if invalid interests" do
      group = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Animals","Fruit"])
      expect(Peer.check_group(group, peer)).to be(false)
    end

  end

  context "#assign_group" do

    it "It will add a person to a group that they will fit in with" do
      group1 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      group2 = [User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)", "Yoga" ).sample]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Wine").sample(2)
      peer = User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)","Yoga").sample
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer, 3)
      expect(new_groups[1].length).to eq(2)
      expect(new_groups[1][1]).to be(peer)
    end

    it "should not add the person to a group that is already full" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Cats","Beer"])
      group1 = [group1_1, group1_2, group1_3]
      group2 = [User.create!(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer, 3)
      expect(new_groups[0].length).to eq(3)
      expect(new_groups[2].length).to eq(3)
      expect(new_groups[2][2]).to be(peer)
    end

    it "should add a group at the end if non of the other groups match" do
      group1 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(3)
      group2 = [] << User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)", "Yoga" ).sample
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Animals","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer, 3)
      expect(new_groups.length).to eq(4)
    end
  end

  context "#works_through_groups" do
    it "Should loop through all the users for Tech and 1 and assign them all tp groups" do
      possible_peers = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1)
      peer_groups = Peer.create_groups([],"Technology", 1)
      expect(peer_groups.flatten.length).to eq(possible_peers.length)
    end
  end

  context "#reassign_not_full_groups" do
    it "Should loop through all the users for Tech and 1 and assign them all to groups if possible" do
      groups = Peer.create_groups([],"Technology", 1)
      outlyers = Peer.get_not_full_groups(groups)
      peer_groups = Peer.reassign_not_full_groups(groups, outlyers)
      new_outlyers = Peer.get_not_full_groups(peer_groups)
      expect(new_outlyers.length <= outlyers.length).to be(true)
    end
  end

  context "#automatially_create_groups" do
    it "Should loop through all the users and make groups" do
      start_group = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: true)
      Peer.automatially_create_groups
      remainder = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false)
      expect(start_group.length > 0).to eq(true)
      expect(remainder.length).to eq(0)
    end
  end

  context "#get_not_full_groups" do
    it "Should return a array of the groups that were are not complete" do
      peer_groups = Peer.get_not_full_groups([[1,2,3],[1,2],[1],[2,3,4]])
      expect(peer_groups.length).to eq(2)
      expect(peer_groups).to eq([[1,2],[1]])
    end
    it "Should return an empty array if nothing is found" do
      peer_groups = Peer.get_not_full_groups([[1,2,3],[1,2,3],[1,3,4],[2,3,4]])
      expect(peer_groups.length).to eq(0)
      expect(peer_groups).to eq([])
    end
  end

end