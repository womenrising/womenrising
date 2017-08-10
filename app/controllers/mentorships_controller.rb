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
    @mentorship = Mentorship.new(mentee_id: current_user.id, question: params[:mentorship][:question])
    if @mentorship.save
      flash[:success] = "Your request for a mentor has been submitted. Mentor matches are run daily, and you will receive an email when you are matched."
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end
end
