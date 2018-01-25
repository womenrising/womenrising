require 'rails_helper'

describe UsersController do
  let!(:user) { create :user }
  let!(:location) { create :location }

  let(:user_params) {
    {
      first_name: 'Test',
      last_name: 'User',
      mentor: false,
      mentor_limit: 3,
      primary_industry: 'Business',
      stage_of_career: 1,
      peer_industry: 'Business',
      current_goal: 'Switching industries',
      location_id: location.id
    }
  }

  before do
    allow_any_instance_of(UsersController).to receive(:current_user).and_return user
  end

  describe '#update' do
    it 'updates all attributes' do
      user_params.merge! top_3_interests: ['Arts', 'Music', 'Crafting']

      subject = patch :update, id: user.id, user: user_params

      expect(user.first_name).to eq 'Test'
      expect(user.peer_industry).to eq 'Business'
      expect(user.current_goal).to eq 'Switching industries'
      expect(user.top_3_interests).to eq ['Arts', 'Music', 'Crafting']
      expect(user.mentor_limit).to eq 3
      expect(user.mentor_times).to eq 3

      expect(subject).to redirect_to(user_path)
    end

    it 'updates attributes without top 3' do
      subject = patch :update, id: user.id, user: user_params

      expect(user.first_name).to eq 'Test'
      expect(user.top_3_interests).to eq []

      expect(subject).to redirect_to(user_path)
    end
  end

  describe '#show' do
    it 'shows a user' do
      get :show, id: user

      expect(response.status).to eq(200)
      expect(assigns(:user)).to eq(user)
    end
  end

  context 'with profile filled out' do
    before do
      subject = patch :update, id: user.id, user: user_params
    end

    describe '#participate' do
      it "changes a user's participation status to true" do
        user.is_participating_this_month = false

        subject = patch :participate, id: user

        expect(user.is_participating_this_month).to eq(true)
        expect(subject).to redirect_to(user_path)
      end
    end

    describe '#not_participate' do
      it "changes a user's participation status to false" do
        user.is_participating_this_month = true

        subject = patch :not_participate, id: user.id

        expect(user.is_participating_this_month).to eq(false)
        expect(subject).to redirect_to(user_path)
      end
    end
  end
end
