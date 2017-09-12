class UsersController < ApplicationController
  before_filter :auth_user

  def show
    permitted_users = User.where(id: current_user.related_user_ids)
    @user = permitted_users.find(params[:id])
  end

  def edit
    @user = current_user
    @industries = User::PRIMARY_INDUSTRY
    @interests = User::TOP_3_INTERESTS
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      @industries = User::PRIMARY_INDUSTRY
      @interests = User::TOP_3_INTERESTS

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
