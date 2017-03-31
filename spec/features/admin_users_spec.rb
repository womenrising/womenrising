require "rails_helper"

describe "admin/users" do

  before :each do
    @admin_user = FactoryGirl.create(:admin_user)
    login_as(@admin_user, :scope => :admin_user)
  end

  describe "GET index page" do
    context "authenticated admin_user" do
      it "should render users index page" do
        2.times { FactoryGirl.create(:user) }
        visit_and_confirm("/admin/users")
      end
    end
  end

  describe "GET show page" do
    context "non authenticated admin_user" do
      it "should rendre user show page" do
        user = FactoryGirl.create(:user)
        visit_and_confirm("/admin/users/#{user.id}")
      end
    end
  end
end
