require 'rails_helper'

describe MentorshipsController do
  let!(:user) { create :user, :not_on_waitlist  }
  let!(:mentor_user) { create :user, :not_on_waitlist }
  let!(:location) { create :location }
  let!(:pending_mentorship) { create :mentorship, mentee: user }
  let!(:other_pending_mentorship) { create :mentorship }
  let!(:completed_mentorship) { create :mentorship, mentee: user, mentor: mentor_user }

  before do
    allow_any_instance_of(MentorshipsController).to receive(:current_user).and_return user
  end

  describe '#destroy' do
    it 'destroys a mentorship' do
      expect do
        delete :destroy, id: pending_mentorship.id
      end.to change{ Mentorship.count }.by(-1)
      expect(flash[:success]).to eq 'Your question has been cancelled'
    end

    it 'does not destroy if there is a mentor' do
      expect do
        delete :destroy, id: completed_mentorship.id
      end.to change{ Mentorship.count }.by(0)

      expect(flash[:danger]).to eq 'Unable to delete active or past mentorships'
    end

    it 'does not destroy other users mentorships' do
      expect(Mentorship.find_by_id(other_pending_mentorship.id)).not_to be_nil

      expect do
        delete :destroy, id: other_pending_mentorship.id
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
