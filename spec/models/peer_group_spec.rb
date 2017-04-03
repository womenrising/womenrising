require 'rails_helper'

describe PeerGroup do
  let!(:location) { create :location }
  context "#generate_groups" do
    let!(:users_to_be_grouped) do
      create_list(:skinny_user, 7, :groupable, location_id: location.id, is_assigned_peer_group: false)
    end

    it "Should loop through all the users and make groups" do
      PeerGroup.generate_groups

      expect(User.where(is_assigned_peer_group: true).length).to eq(7)
      expect(User.where(is_assigned_peer_group: false).length).to eq(0)
      expect(PeerGroup.all.length).to be(2)
    end
  end

  context "with 200 random users that can be grouped" do
    before do
      create_list(:skinny_user, 200, :groupable, :any_stage_of_career, location_id: location.id)
    end

    context "#automatically_create_groups" do
      before do
        @start_group = User.all
        @groups = PeerGroup.automatically_create_groups
      end

      it "should loop through and assign groups" do
        @groups.each do |group|
          expect(group.length.between? 2, 4).to be(true)
        end
        expect(@groups.flatten.length).to eq(@start_group.length)
        expect(@groups.is_a?(Array)).to be(true)
      end
    end
  end
end
