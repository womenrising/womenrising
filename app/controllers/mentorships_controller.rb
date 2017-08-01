class MentorshipsController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def new
    @user = current_user
    @mentorship = Mentorship.new()
    @industries = ["Technology", "Business", "Startup"]
  end

  def create
    @user = current_user
    @mentorship = Mentorship.new(mentee_id: current_user.id, question: params[:mentor][:question])
    if @mentorship.save
      @mentorship.send_mail

      action = :new_mentor
      message  = "User id #{@user.id} is a new mentor"
      SlackNotification.notify(action, message)

      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end
end
