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
      expect(user.peer_industry).to eq("Technology")
      expect(user.stage_of_career).to eq(1)
      expect(user).to_not eq(nil)
    end

    it "should give you one invalid user for 1 Other" do
      peer = Peer.new
      expect(peer.get_first_peer("Other", 3)).to be(nil)
    end
  end

  context "#get_other_peers" do
    it "Should find a peer for Technology and 1" do
      peer = Peer.new
      first_peer = peer.get_first_peer("Technology", 1)
      current_peer = peer.get_other_peers(first_peer)
      expect(current_peer.length).to eq(2)
    end
  end

end 