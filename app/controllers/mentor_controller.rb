class MentorController < ApplicationController
  
  def new
    @user = current_user
  end

  def create
    @user = current_user
  end
end
