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
  context "#get_first_peer" do
    it "should give you one valid user for 1 Technology" do
      peer = Peer.new
      user = peer.get_first_peer("Technology", 1)
      first_user = user[0]
      expect(first_user.peer_industry).to eq("Technology")
      expect(first_user.stage_of_career).to eq(1)
      expect(user.length).to eq(1)
    end

    it "should give you one valid user for 1 Business" do
      peer = Peer.new
      user = peer.get_first_peer("Business", 5)
      first_user = user[0]
      expect(first_user.peer_industry).to eq("Business")
      expect(first_user.stage_of_career).to eq(5)
      expect(user.length).to eq(1)
    end

    it "should give you one invalid user for 1 Other" do
      peer = Peer.new
      user = peer.get_first_peer("Other", 3)
      first_user = user[0]
      expect(first_user).to be(nil)
      expect(user).to match_array([nil])
      expect(user.length).to eq(1)
    end
  end

  context "#get_other_peers" do
    it "Should find a peer " do

    end
  end

  context "#averge_stage_of_career" do
    it "should return the average stage of career given two of the same should be the same" do
      peer = Peer.new
      peer_group = User.where(live_in_detroit:true, is_participating_this_month: true, waitlist: false, is_assigned_peer_group: false).where("peer_industry = ? AND stage_of_career = ?", "Technology", 1).sample(2)
      average = peer.average_stage_of_career(peer_group)
      expect(average).to eq(1)
    end      
  end
end
