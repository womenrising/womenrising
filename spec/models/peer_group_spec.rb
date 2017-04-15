require 'rails_helper'

describe PeerGroup do
  context "#generate_groups" do
    before do
      clear_emails
      create_list(:skinny_user, 7, :groupable, is_assigned_peer_group: false)
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

  context "with 200 random users that can be grouped" do
    before do
      create_list(:skinny_user, 200, :groupable, :any_stage_of_career)
    end

    context "#automatically_create_groups" do
      before do
        @start_group = User.all
        @groups = PeerGroup.automatically_create_groups
      end

      it "should loop through and assign groups" do
        expect(@groups.flatten.length).to eq(@start_group.length)
        expect(@groups.is_a?(Array)).to be(true)
      end
    end
  end
end
