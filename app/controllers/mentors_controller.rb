class MentorsController < ApplicationController
  
  def new
    @user = current_user
    @mentor = Mentor.new()
    @industries = ["Technology", "Business", "Startup"]
  end

  def create
    @user = current_user
  end
end
