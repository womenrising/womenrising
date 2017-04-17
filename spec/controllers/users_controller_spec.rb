require 'rails_helper'

describe UsersController do
  let!(:user) { create :skinny_user }
  let!(:location) { create :location }

  let(:user_params) { {
    first_name: 'Test',
    last_name: 'User',
    mentor: false,
    mentor_limit: 3,
    primary_industry: 'Business',
    stage_of_career: 1,
    mentor_industry: 'Business',
    peer_industry: 'Business',
    current_goal: 'Switching industries',
    location_id: 1,
  } }

  before do
    allow_any_instance_of(UsersController).to receive(:current_user).and_return user
  end

  describe '#update' do
    it 'updates all attributes' do
      user_params.merge! top_3_interests: ["Arts", "Music", "Crafting"]

      put :update, id: user, user: user_params
      expect(user.first_name).to eq 'Test'
      expect(user.mentor_industry).to eq 'Business'
      expect(user.peer_industry).to eq 'Business'
      expect(user.current_goal).to eq 'Switching industries'
      expect(user.top_3_interests).to eq ["Arts", "Music", "Crafting"]
      expect(user.mentor_limit).to eq 3
      expect(user.mentor_times).to eq 3
    end

    it 'updates attributes without top 3' do
      put :update, id: user, user: user_params
      expect(user.first_name).to eq 'Test'
      expect(user.top_3_interests).to eq []
    end
  end
end
