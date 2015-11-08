class UsersController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
    @industries = ["Business", "Technology", "Startup"]
    @interests = ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events","Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"]
  end

  def update
    @user = current_user
    if @user.update(first_name:params[:user][:first_name],last_name:params[:user][:last_name],mentor:params[:user][:mentor],mentor_limit:params[:user][:mentor_limit], mentor_times: @user.mentor_times_change(params[:user][:mentor_limit]), primary_industry:params[:user][:primary_industry],stage_of_career:params[:user][:stage_of_career],mentor_industry:params[:user][:mentor_industry], peer_industry:params[:user][:peer_industry],current_goal:params[:user][:current_goal],top_3_interests:params[:user][:top_3_interests] || [],live_in_detroit:params[:user][:live_in_detroit])
      redirect_to user_path(current_user)
    else
      @industries = ["Business", "Technology", "Startup"]
      @interests = ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events","Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"]
      render 'edit'
    end
  end

  def participate
    @user = current_user
    @user.update(is_participating_this_month: true)
    redirect_to user_path(current_user)
  end

  def not_participate
    @user = current_user
    @user.update(is_participating_this_month: false)
    redirect_to user_path(current_user)
  end

end
