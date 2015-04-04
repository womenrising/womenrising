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


end