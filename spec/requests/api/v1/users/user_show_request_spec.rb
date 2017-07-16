require 'rails_helper'

describe 'users returns info for single user' do
  it 'returns user by id' do
    users = create_list(:user, 3)

    get "/api/v1/users/#{users.first.id}"

    expect(response).to be_success

    user = JSON.parse(response.body)
    
    expect(user["first_name"]).to eq(users.first.first_name)
    expect(user["last_name"]).to eq(users.first.last_name)
    expect(user["is_participating_this_month"]).to eq(users.first.is_participating_this_month)
  end
end