require 'rails_helper'

describe 'users returns info for single user' do
  let(:location) { create :location }
  let!(:user) { create :user, :groupable, location: location }
  let!(:user_in_current_group) { create :user, :groupable, location: location }
  let!(:user_in_other_group) { create :user, :groupable }

  before do
    login_as(user, scope: :user)
    PeerGroup.generate_groups
  end

  it 'returns user first name, last name, city, and peers for given user id' do
    get "/api/v1/users/#{user.id}"

    expect(response).to be_success

    parsed_user = JSON.parse(response.body)
binding.pry
    expect(parsed_user).to be_a(Hash)
    expect(parsed_user["first_name"]).to eq(user.first_name)
    expect(parsed_user["last_name"]).to eq(user.last_name)
    expect(parsed_user["city"]).to eq(user.city)
    expect(parsed_user["peers"]).to be_an(Array)
    expect(parsed_user["peers"].count).to eq(1)
    expect(parsed_user["peers"].first["email"]).to eq(user.peers.first.email)
    expect(parsed_user["peers"].first["first_name"]).to eq(user.peers.first.first_name)
    expect(parsed_user["peers"].first["last_name"]).to eq(user.peers.first.last_name)
    expect(parsed_user["peers"].first["image_url"]).to eq(user.peers.first.image_url)
    expect(parsed_user["peers"].first["linkedin_url"]).to eq(user.peers.first.linkedin_url)
  end
end