require 'rails_helper'

describe 'admin/users' do

  before do
    @admin_user = FactoryBot.create(:admin_user)
    login_as(@admin_user, :scope => :admin_user)
  end

  describe 'GET index page' do
    context 'authenticated admin_user' do
      it 'should render users index page' do
        2.times { FactoryBot.create(:user) }
        visit_and_confirm('/admin/users')
      end
    end
  end

  describe 'GET show page' do
    context 'non authenticated admin_user' do
      it 'should rendre user show page' do
        user = FactoryBot.create(:user)
        visit_and_confirm("/admin/users/#{user.id}")
      end
    end
  end
end
