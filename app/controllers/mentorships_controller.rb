class MentorshipsController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def new
    @user = current_user
    @mentorship = Mentorship.new()
    @industries = ['Technology', 'Business', 'Startup']
  end

  def create
    @user = current_user
    @mentorship = Mentorship.new(mentee_id: current_user.id, question: params[:mentorship][:question])

    if @mentorship.save
      flash[:success] = 'Your request for a mentor has been submitted. Mentor matches are run daily, and you will receive an email when you are matched.'
      redirect_to user_path(current_user)
    else
      flash[:danger] = @mentorship.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def destroy
    @mentorship = policy_scope(Mentorship).find(params[:id])
    if @mentorship.mentor
      flash[:danger] = 'Unable to delete active or past mentorships'
      redirect_to user_path(current_user)
    else
      @mentorship.destroy
      flash[:success] = 'Your question has been cancelled'
      redirect_to user_path(current_user)
    end
  end

  private

  def policy_scope scope
    scope.where(mentee: current_user)
  end
end
