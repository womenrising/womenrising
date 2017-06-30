ActiveAdmin.register User do

  config.comments = false

  index do
    column :id
    column :email
    column :first_name
    column :last_name
    column :mentor
    column :primary_industry
    column :stage_of_career
    column :location
    column :zip_code

    actions
  end

  form do |f|
    inputs 'Details' do
      input :email
      input :first_name
      input :last_name
      input :mentor
      input :primary_industry
      input :stage_of_career
      input :mentor_industry
      input :peer_industry
      input :current_goal
      input :top_3_interests
      input :location
      input :zip_code
      input :waitlist
      input :mentor_times
      input :mentor_limit
      input :is_participating_this_month
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :mentor
      row :primary_industry
      # row :stage_of_career do |user|
      #   # stage_of_career -1 because the array of neames starts at 1
      #   User::STAGE_OF_CAREER[user.stage_of_career-1]
      # end
      row :mentor_industry
      row :peer_industry
      row :current_goal
      row :top_3_interests
      row :location
      row :zip_code
      row :waitlist
      row :mentor_times
      row :mentor_limit
      row :is_participating_this_month
    end
  end

  member_action :login_as, method: :put do
    user = resource
    sign_in(:user, user)
    redirect_to user
  end

  action_item :view, only: :show do
    link_to 'Login In As', login_as_admin_user_path(user), method: :put
  end

  collection_action :run_matches, method: :post do
    User.update_month
    redirect_to admin_users_path, notice: "Ran Monthly Matches"
  end

  action_item :view, only: :index do
    link_to "Run Monthly Matching", run_matches_admin_users_path, method: :post
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
