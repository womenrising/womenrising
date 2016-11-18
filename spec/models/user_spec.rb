require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    allow(SlackNotification).to receive(:notify)
  end
  let(:user) { FactoryGirl.create(:skinny_user) }

  describe 'validations' do
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }
  end

  describe '.update_month' do
    #update_month 'refreshes' user settings for next month

    context 'if user is participating this month' do
      let!(:participating_user) do
        FactoryGirl.create(:skinny_user,
                           is_participating_this_month: true,
                           is_assigned_peer_group: true,
                           mentor_times: 3,
                           mentor_limit: 4)
      end

      before do
        User.update_month
        participating_user.reload
      end

      it 'resets is_participating_this_month back to false' do
        expect(participating_user.is_participating_this_month).to eq(false)
      end

      it 'resets is_assigned_peer_group back to false' do
        expect(participating_user.is_assigned_peer_group).to eq(false)
      end

      it 'resets the user\'s mentor times to their stated mentor_limit' do
        # the 'mentor limit' is how often a user is willing to mentor in a month.
        # mentor_times is a number that is originally set to a user's specified
        # mentor_limit, but is decremented each time the user meets with their mentees.
        # Once mentor_times gets to 0, a mentor can no longer be matched with a mentee.
        # We reset the mentor_times to mentor_limit each month.
        expect(participating_user.mentor_times).to eq(4)
      end
    end

    context 'if user is not participating this month' do
      let!(:opted_out_user) do
        FactoryGirl.create(:skinny_user,
                           is_participating_this_month: false,
                           mentor_times: 10)
      end

      it 'sets the user\'s mentor times to 0 so they will not be matched' do
        User.update_month
        opted_out_user.reload

        expect(opted_out_user.mentor_times).to eq(0)
      end
    end
  end

  describe "#check_industry" do
    # check industry is a callback that triggers waitlisting
    ## TODO: can these be validations? Why waitlist?
    context 'if user has no goal' do
      it 'flags the user as waitlisted' do
        user = FactoryGirl.create(:skinny_user, current_goal: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has specified their primary industry as \'Other\'' do
      it 'flags the user as waitlisted' do
        user = FactoryGirl.create(:skinny_user, primary_industry: 'Other')
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has no primary_industry' do
      it 'flags the user as waitlisted' do
        user = FactoryGirl.create(:skinny_user, primary_industry: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has no peer_industry' do
      # peer industry is the industry in which
      # they are interested in meeting other people in
      it 'flags the user as waitlisted' do
        user = FactoryGirl.create(:skinny_user, peer_industry: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has blank top_3_interests' do
      it 'flags the user as waitlisted' do
        user = FactoryGirl.create(:skinny_user, top_3_interests: [])
        expect(user.waitlist).to eq(true)
      end
    end

    context 'with all necessary values' do
      it 'does not waitlist the user' do
        user = FactoryGirl.create(:skinny_user,
                                  :with_interests,
                                  :with_goal,
                                  :technology_primary_industry,
                                  peer_industry: "Business")
        expect(user.waitlist).to eq(false)
      end
    end
  end

  describe '#mentor_times_change' do
    # this is a method called in users#update that updates a user's mentor_times
    # based on a new mentor limit submitted by the user in a form.
    # If a user decides midway through the month to change their mentor_limit,
    # this method makes sure that, based on any mentoring they have done already,
    # their mentor_times get set appropriately.

    it "should 0 if the change makes it negative" do
      user = FactoryGirl.create(:skinny_user, mentor_times: 0, mentor_limit: 1)
      expect(user.mentor_times_change(0)).to eq(0)
    end

    it "should return higher but not the full limit if the change is greater than the limit but one of the mentor times is gone" do
      user = FactoryGirl.create(:skinny_user, mentor_times: 0, mentor_limit: 1)
      expect(user.mentor_times_change(4)).to eq(3)
    end

    it "should return higher if the change is greater than the limit" do
      user = FactoryGirl.create(:skinny_user, mentor_times: 1, mentor_limit: 1)
      expect(user.mentor_times_change(4)).to eq(4)
    end

    it "should return lower if there is still mentor times" do
      user = FactoryGirl.create(:skinny_user, mentor_times: 3, mentor_limit: 3)
      expect(user.mentor_times_change(2)).to eq(2)
    end

    it "should return the same amount if nothing changes" do
      user = FactoryGirl.create(:skinny_user, mentor_times: 2, mentor_limit: 3)
      expect(user.mentor_times_change(3)).to eq(2)
    end
  end
end
