require 'rails_helper'

describe PeerGroup do
  let!(:boulder) { create :location }
  context "#generate_groups" do
    before do
      clear_emails
      create_list(:skinny_user, 7, :groupable, location_id: boulder.id)
      PeerGroup.generate_groups
    end

    it "Should loop through all the users and make groups" do
      expect(User.where(is_assigned_peer_group: true).length).to eq(7)
      expect(User.where(is_assigned_peer_group: false).length).to eq(0)
      expect(PeerGroup.all.length).to be(2)
    end


    it "sends emails to peers with correct information" do
      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.map(&:to).flatten.count).to eq(7)

      group = PeerGroup.take
      open_email(group.users.take.email)
      group.users.each do |user|
        expect(current_email).to have_content user.first_name
        expect(current_email).to have_content user.last_name
        expect(current_email).to have_content user.email
        expect(current_email).to have_content user.top_3_interests.join(', ')
        expect(current_email).to have_css "[href='#{user.linkedin_url}']"
      end
    end
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
      groups = PeerGroup.all.map(&:users)
      detroit_group = groups.select{|g| g.include?(detroit_users.first)}.first

      expect(groups.count).to eq(2)
      expect(detroit_group).to match_array(detroit_users)
      expect(detroit_group).to_not match_array(boulder_users)
    end
  end

  context "with 200 random users that can be grouped" do
    let(:users) do
      create_list(:skinny_user, 200, :groupable, :any_stage_of_career,
                  location_id: boulder.id)
    end

    context "#automatically_create_groups(location)" do
      it "should loop through and assign groups" do
        start_group = User.all
        groups = PeerGroup.automatically_create_groups(boulder)

        groups.each do |group|
          expect(group.length.between? 2, 4).to be(true)
        end
        expect(groups.flatten.length).to eq(start_group.length)
        expect(groups.is_a?(Array)).to be(true)
      end
    end
  end
end
