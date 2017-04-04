require 'rails_helper'

describe PeerGroup do
  let!(:boulder) { create :location }
  context "#generate_groups" do
    it "Should loop through all the users and make groups" do
      users_to_be_grouped = create_list(:skinny_user, 7, :groupable, location_id: boulder.id)

      PeerGroup.generate_groups

      expect(User.where(is_assigned_peer_group: true).length).to eq(7)
      expect(User.where(is_assigned_peer_group: false).length).to eq(0)
      expect(PeerGroup.all.length).to be(2)
    end

    context "assigns users based on location" do
      let!(:boulder_users) do
        create_list(:skinny_user, 2, :groupable, location_id: boulder.id)
      end

      let(:detroit) { create :location, city: "Detroit"}
      let!(:detroit_users) do
        create_list(:skinny_user, 2, :groupable, location_id: detroit.id)
      end

      it "does not group denver user with detroit users" do
        PeerGroup.generate_groups
        @groups = PeerGroup.all.map(&:users)
        detroit_group = @groups.select{|g| g.include?(detroit_users.first)}.first

        expect(@groups.count).to eq(2)
        expect(detroit_group).to match_array(detroit_users)
        expect(detroit_group).to_not match_array(boulder_users)
      end
    end
  end

  context "with 200 random users that can be grouped" do
    before do
      create_list(:skinny_user, 200, :groupable, :any_stage_of_career, location_id: boulder.id)
    end

    context "#automatically_create_groups(location)" do
      before do
        @start_group = User.all
        @groups = PeerGroup.automatically_create_groups(boulder)
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
