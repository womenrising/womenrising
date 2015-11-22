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
    column :live_in_detroit

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
      input :live_in_detroit
      input :waitlist
      input :is_participating_next_month
      input :is_assigned_peer_group
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
      row :stage_of_career do |user|
        # stage_of_career -1 because the array of neames starts at 1
        User::STAGE_OF_CAREER[user.stage_of_career-1]
      end
      row :mentor_industry
      row :peer_industry
      row :current_goal
      row :top_3_interests
      row :live_in_detroit
      row :waitlist
      row :is_participating_next_month
      row :mentor_times
      row :mentor_limit
      row :is_participating_this_month
    end
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end

