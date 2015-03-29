class MentorsController < ApplicationController
  
  def new
    @user = current_user
    @mentor = Mentor.new()
    @industries = ["Technology", "Business", "Startup"]
  end

  def create
    @user = current_user
    @mentor = Mentor.new(mentee_id: current_user.id, question: params[:mentor][:question])
    if @mentor.save
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end
end
