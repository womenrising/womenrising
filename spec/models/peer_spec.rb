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
    it "should " do
      group = Peer.get_peer_group("Technology",1)
      expect(group).not_to be_empty 
    end
  end

  context "#self.get_one_peer" do
    it "should get a single " do
      peer = Peer.get_one_peer(Peer.get_peer_group("Technology",1))
      expect(peer).to be_an_instance_of(User)
    end
  end

  context "#self.remove_peer(group, peer)" do
    it "should get a single " do
      group = Peer.get_peer_group("Technology",1)
      peer = Peer.get_one_peer(group)
      expect(Peer.remove_peer(group, peer).count).to eq(group.length - 1)
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
      group = User.where("? = ANY(top_3_interests)", "Cats").sample(2)
      expect(Peer.get_group_interests(group)).not_to be_empty
      expect(Peer.get_group_interests(group)).to include("Cats")
     end
  end

  context "#check_group" do
    it "should return true if valid" do
      group = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(3)
      peer = group.pop
      expect(Peer.check_group(group, peer)).to eq(true)
    end

    it "should return false if they don't have the same current_goal" do
      group = User.where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.where("current_goal != ? ", "Switching industries").sample
      expect(Peer.check_group(group, peer)).to be(false)
    end

    it "should return false if invalid interests" do
      group = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      peer = User.create(email: "hello@gmail.com", password_confirmation: "Howearesese12", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Animals","Fruit"])
      expect(Peer.check_group(group, peer)).to be(false)
    end

  end

  context "#adding_to_peer_groups" do

    it "should add the peer if check group returns true" do
      group1 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
      group2 = [] << User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)", "Yoga" ).sample
      group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Wine").sample(2)
      peer = User.where(current_goal: "Switching industries").where("? = ANY(top_3_interests)","Yoga").sample
      groups = [group1,group2,group3]
      new_groups = Peer.assign_group(groups, peer)
      expect(new_groups[1].length).to eq(2)
      expect(new_groups[1][1]).to be(peer)
    end
  end

end