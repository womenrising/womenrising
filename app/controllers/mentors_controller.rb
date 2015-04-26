class MentorsController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end
  
  def new
    @user = current_user
    @mentor = Mentor.new()
    @industries = ["Technology", "Business", "Startup"]
  end

  def create
    @user = current_user
    @mentor = Mentor.new(mentee_id: current_user.id, question: params[:mentor][:question])
    if @mentor.save
      @mentor.send_mail
      redirect_to user_path(current_user)
    else
      p @mentor.errors.full_messages
      render 'new'
    end
  end
end
