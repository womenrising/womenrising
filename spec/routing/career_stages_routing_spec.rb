require "rails_helper"

RSpec.describe CareerStagesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/career_stages").to route_to("career_stages#index")
    end

    it "routes to #new" do
      expect(:get => "/career_stages/new").to route_to("career_stages#new")
    end

    it "routes to #show" do
      expect(:get => "/career_stages/1").to route_to("career_stages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/career_stages/1/edit").to route_to("career_stages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/career_stages").to route_to("career_stages#create")
    end

    it "routes to #update" do
      expect(:put => "/career_stages/1").to route_to("career_stages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/career_stages/1").to route_to("career_stages#destroy", :id => "1")
    end

  end
end
