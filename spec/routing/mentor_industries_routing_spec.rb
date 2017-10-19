require "rails_helper"

RSpec.describe MentorIndustriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/mentor_industries").to route_to("mentor_industries#index")
    end

    it "routes to #new" do
      expect(:get => "/mentor_industries/new").to route_to("mentor_industries#new")
    end

    it "routes to #show" do
      expect(:get => "/mentor_industries/1").to route_to("mentor_industries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mentor_industries/1/edit").to route_to("mentor_industries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/mentor_industries").to route_to("mentor_industries#create")
    end

    it "routes to #update" do
      expect(:put => "/mentor_industries/1").to route_to("mentor_industries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mentor_industries/1").to route_to("mentor_industries#destroy", :id => "1")
    end

  end
end
