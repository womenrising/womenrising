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

  context "#generate_groups" do
    it "Should loop through all the users and make groups" do
      start_group = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: true)
      Peer.generate_groups
      remainder = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false)
      users = User.where(is_assigned_peer_group: true)
      expect(start_group.length > 0).to eq(true)
      expect(remainder.length).to eq(0)
      expect(users.length).to eq(start_group.length)
      expect(Peer.all.length > 0).to be(true)
    end
  end

  context "#automatially_create_groups" do
    it "should loop through and assign groups" do
      start_group = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true)
      groups = Peer.automatially_create_groups
      groups.each do |group|
        expect(group.length < 3).to be(false)
      end
      expect(groups.flatten.length).to eq(start_group.length)
      expect(groups.is_a?(Array)).to be(true)
    end
  end

  context "#self.get_peers" do
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
      group1_1 = User.create(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group = [group1_1, group1_2]
      peer = User.create(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      expect(Peer.check_group(group, peer)).to eq(true)
    end

    it "should return false if they don't have the same current_goal" do
      group1_1 = User.create(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group = [group1_1, group1_2]
       peer = User.create(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Switching Industries", top_3_interests: ["Anime", "Cats","Fruit"])
      expect(Peer.check_group(group, peer)).to be(false)
    end

    it "should return false if invalid interests" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group = [group1_1, group1_2]
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Animals","Fruit"])
      expect(Peer.check_group(group, peer)).to be(false)
    end

  end

  context "#assign_group" do

    it "It will add a person to a group that they will fit in with" do
      group1 = [User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Beatles", "Birds","Bacon"]), User.create!(email: "hello122@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Birds","Bats"])]
      group2 = [User.create!(email: "hello234@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Bubbles", "Yoga","Bacon"])]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Wine").sample(2)
      peer = User.create!(email: "hello23403432@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Yoga","Bats"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer)
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
      new_groups = Peer.assign_group(groups, peer)
      expect(new_groups[0].length).to eq(3)
      expect(new_groups[2].length).to eq(3)
      expect(new_groups[2][2]).to be(peer)
    end

    it "should add a group at the end if non of the other groups match" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Cats","Beer"])
      group1 = [group1_1, group1_2, group1_3]
      group2 = [] << User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)", "Yoga" ).sample
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Animals","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer)
      expect(new_groups.length).to eq(4)
    end
  end

  context "#create_groups" do
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

  context "#assign_group_no_cg" do
    it "should assign peer based on interest and will assign if less than 3" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Cats","Beer"])
      group1 = [group1_1, group1_2, group1_3]
      group2 = [User.create!(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "Cats","bats"])]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Dogs").sample(2)
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Switching Industries", top_3_interests: ["Anime", "Cats","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group_no_cg(groups, peer)
      expect(new_groups.length).to eq(3)
      expect(new_groups[0].length).to eq(3)
      expect(new_groups[1].length).to eq(2)
    end

    it "should assign peer based on interest" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1 = [group1_1, group1_2]
      group2 = [User.create!(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group_no_cg(groups, peer)
      expect(new_groups.length).to eq(3)
      expect(new_groups[0].length).to eq(3)
    end

    it "should create a new one if doesn't fit in any" do
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
      group1 = [group1_1, group1_2, group1_3]
      group2 = [User.create!(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])]
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Dogs").sample(2)
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group_no_cg(groups, peer)
      expect(new_groups[0].length).to eq(3)
      expect(new_groups[3].length).to eq(1)
    end
  end

  context "#assign_group_no_checks" do
    it 'should create groups if there is more than 4' do
      group = [[1,2,3],[1,2,3,4],[1,2,3]]
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
      group1 = [group1_1, group1_2, group1_3]
      new_groups = Peer.assign_group_no_checks(group, group1)
      expect(new_groups.length).to eq(4)
    end

    it 'should create groups if there is more than 4' do
      group = [[1,2,3],[1,2,3,4],[1,2,3]]
      group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
      group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
      group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
      group1_4 = User.create!(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])
      peer = User.create!(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
      group1 = [group1_1, group1_2, group1_3, group1_4, peer]
      new_groups = Peer.assign_group_no_checks(group, group1)
      expect(new_groups.length).to eq(4)
      expect(new_groups[2].length).to eq(4)
      expect(new_groups[0].length).to eq(4)
      expect(new_groups[-1].length).to eq(3)
    end
  end

  context "#assign_to_group_of_three" do
    it "should assign a peer to a group of three" do
      group = Peer.assign_to_group_of_three([[1,2,3],[1,2]], 5)
      expect(group[0].length).to eq(4)
      expect(group[0]).to eq([1,2,3,5])
    end

    it "should not assign the peer to a group of 4" do
      group = Peer.assign_to_group_of_three([[1,2,3,4],[1,2]], 5)
      expect(group[0].length).to eq(4)
      expect(group[1]).to eq([1,2,5])
    end
  end

  context "#get_singles" do
    it "should get all groups with just one person in it" do
       group = [[1,2,3],[1],[1,2],[1,2,3],[1],[1],[1,2]]
       single_groups = Peer.get_singles(group)
       expect(single_groups.length).to eq(3)
       expect(single_groups).to eq([[1],[1],[1]])
    end
  end
 
  # def "#create_peer_groups" do
  #   group1_1 = User.create!(email: "hello2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"],is_assigned_peer_group:false)
  #     group1_2 = User.create!(email: "hello3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"], is_assigned_peer_group:false)
  #     group1_3 = User.create!(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"], is_assigned_peer_group:false)
  #     group = [group1_1, group1_3, group1_2]
  #     group1_1 = User.create!(email: "hello2w323@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"],is_assigned_peer_group:false)
  #     group1_2 = User.create!(email: "hell23423o3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"], is_assigned_peer_group:true)
  #     group1_3 = User.create!(email: "hell23423o4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"], is_assigned_peer_group:false)
  #     group2 = [group1_1, group1_3, group1_2]
  #     groups = [group, group2]
  #     expect()
  #   end



end