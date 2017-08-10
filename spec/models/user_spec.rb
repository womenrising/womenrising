require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    allow(SlackNotification).to receive(:notify)
  end
  let(:user) { create(:user) }

  describe 'validations' do
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }
  end

  describe 'assigns location' do
    let!(:location) { Location.create(city: 'Detroit', state: 'MI')}
    let(:user) { create(:user, location_id: location.id) }

    scenario 'user has a location' do
      expect(user.location_id).to_not be_nil
    end
  end

  describe '.update_month' do
    #update_month 'refreshes' user settings for next month

    context 'if user is participating this month' do
      let!(:participating_user) do
        create(:user,
               is_participating_this_month: true,
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
        create(:user,
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

  describe '#check_industry' do
    # check industry is a callback that triggers waitlisting
    ## TODO: can these be validations? Why waitlist?
    context 'if user has no goal' do
      it 'flags the user as waitlisted' do
        user = create(:user, current_goal: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has specified their primary industry as \'Other\'' do
      it 'flags the user as waitlisted' do
        user = create(:user, primary_industry: 'Other')
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has no primary_industry' do
      it 'flags the user as waitlisted' do
        user = create(:user, primary_industry: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has no peer_industry' do
      # peer industry is the industry in which
      # they are interested in meeting other people in
      it 'flags the user as waitlisted' do
        user = create(:user, peer_industry: nil)
        expect(user.waitlist).to eq(true)
      end
    end

    context 'if user has blank top_3_interests' do
      it 'flags the user as waitlisted' do
        user = create(:user, top_3_interests: [])
        expect(user.waitlist).to eq(true)
      end
    end

    context 'with all necessary values' do
      it 'does not waitlist the user' do
        user = create(:user,
                      :with_interests,
                      :with_goal,
                      :technology_primary_industry,
                      peer_industry: "Business")
        expect(user.waitlist).to eq(false)
      end
    end
  end

  describe '#mentor_limit=' do
    # sets a new value for mentor_times
    # based on a new mentor limit submitted by the user in a form.
    # If a user decides midway through the month to change their mentor_limit,
    # this method makes sure that, based on any mentoring they have done already,
    # their mentor_times get set appropriately.
    context 'when the new mentor_limit would make mentor_times negative' do
      it 'returns 0 as the new value for mentor_times' do
        user = create(:user, mentor_times: 0, mentor_limit: 1)
        user.mentor_limit = 0
        expect(user.mentor_times).to eq(0)
      end
    end

    context 'when the new mentor_limit is higher than old mentor_limit' do
      context 'but user has not yet mentored this month' do
        it 'returns a higher value for mentor_times' do
          user = create(:user, mentor_times: 1, mentor_limit: 1)
          user.mentor_limit = 4
          expect(user.mentor_times).to eq(4)
          expect(user.mentor_limit).to eq(4)
        end
      end

      context 'but the mentor has mentored already' do
        it 'subtracts the number of mentor meetings from the new mentor_times' do
          user = create(:user, mentor_times: 0, mentor_limit: 1)
          user.mentor_limit = 4
          expect(user.mentor_times).to eq(3)
        end
      end
    end

    context 'when the new mentor_limit is lower than the old mentor_limit' do
      context 'and less than the old mentor_times' do
        it 'should set the new value for mentor_times as the new mentor_limit' do
          user = create(:user, mentor_limit: 3)
          user.update(mentor_times: 3)
          user.mentor_limit = 2
          expect(user.mentor_times).to eq(2)
        end
      end
    end

    context 'when the new mentor limit is the same as the old' do
      it 'does not change the mentor_times value' do
        user = create(:user, mentor_limit: 3)
        user.update(mentor_times: 2)
        user.mentor_limit = 3
        expect(user.mentor_times).to eq(2)
      end
    end
  end

  describe ".mentors" do
    let!(:mentor) { create(:mentor) }
    let!(:mentee) { create(:mentee) }

    it "returns all mentors" do
      mentors = described_class.mentors
      expect(mentors).to include(mentor)
      expect(mentors).to_not include(mentee)
    end
  end

  context 'with groups' do
    let!(:user_in_current_group) { create :user, :groupable }
    let!(:user_in_previous_group) { create :user, :groupable }
    let!(:user_in_other_group) { create :user, :groupable }

    before do
      PeerGroup.create users: [user_in_other_group]
      PeerGroup.create users: [user, user_in_previous_group], created_at: 2.months.ago
    end

    describe '#current_peer_group' do
      it 'is the latest group within the past month' do
        current_group = PeerGroup.create users: [user, user_in_current_group], created_at: 1.month.ago
        expect(user.current_peer_group).to eq current_group
      end

      it 'is nil if the latest group is two months ago' do
        expect(user.current_peer_group).to be_nil
      end
    end

    describe '#peers' do
      it 'does not contain self' do
        PeerGroup.create users: [user, user_in_current_group], created_at: 1.month.ago
        expect(user.peers).to_not include user
      end

      it 'contains users in current group' do
        PeerGroup.create users: [user, user_in_current_group], created_at: 1.month.ago
        expect(user.peers).to include user_in_current_group
        expect(user.peers).to_not include user_in_other_group
      end

      it 'does not contain users in previous group' do
        expect(user.peers).to_not include user_in_previous_group
      end
    end
  end
end
