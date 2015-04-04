require 'rails_helper'

describe Peer do
  it { should belong_to(:peer1)}
  it { should belong_to(:peer2)}
  it { should belong_to(:peer3)}
  it { should belong_to(:peer4)}

  it "can get users" do
    FactoryGirl.create(:user).should be_valid
  end
 
  before{300.times{FactoryGirl.create(:user)}}
  it "Should have a database of 300 users" do
    expect(User.all.count).to eq(300)
  end

  it "should give you one valid user for 1" do
    peer = Peer.new
    user = peer.get_first_peer("Technology", 1)
    first_user = user[0]
    expect(first_user.peer_industry).to eq("Technology")
    expect(first_user.stage_of_career).to eq(1)
    expect(user.length).to eq(1)
  end

  it "should give you one valid user for 1" do
    peer = Peer.new
    user = peer.get_first_peer("Business", 5)
    first_user = user[0]
    expect(first_user.peer_industry).to eq("Business")
    expect(first_user.stage_of_career).to eq(5)
    expect(user.length).to eq(1)
  end

  it "should give you one valid user for 1" do
    peer = Peer.new
    user = peer.get_first_peer("Other", 3)
    first_user = user[0]
    expect(first_user).to be(nil)
    expect(user).to match_array([nil])
    expect(user.length).to eq(1)
  end
  
end
