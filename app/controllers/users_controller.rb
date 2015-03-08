class UsersController < ApplicationController

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(first_name:params[:user][:first_name],last_name:params[:user][:last_name],mentor:params[:user][:mentor],primary_industry:params[:user][:primary_industry],stage_of_career:params[:user][:stage_of_career],mentor_industry:params[:user][:mentor_industry],current_goal:params[:user][:current_goal],top_3_interests:params[:user][:top_3_interests],live_in_detroit:params[:user][:live_in_detroit])
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end
end
