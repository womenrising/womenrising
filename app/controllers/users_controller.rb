class UsersController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
    @industries = ["Business", "Technology", "Startup"]
    @interests = ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events","Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"]
  end

  def update
    @user = current_user
    if @user.update(user_params)
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

    action = :user_participating
    message  = "User id #{@user.id} is participating"
    SlackNotification.notify(action, message)

    redirect_to user_path(current_user)
  end

  def not_participate
    @user = current_user
    @user.update(is_participating_this_month: false)
    redirect_to user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :mentor,
      :mentor_limit,
      :primary_industry,
      :stage_of_career,
      :mentor_industry,
      :peer_industry,
      :current_goal,
      :location_id,
      :zip_code,
      top_3_interests: []
    )
  end
end
