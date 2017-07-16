Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :session => 'custom/devise/sessions'}, :skip => [:registrations]

  resources :users
  resources :mentors
  resources :locations, only: [:index, :show]

  get 'users/:id/will_participate' => 'users#participate', as: :participate
  get 'users/:id/will_not_participate' => 'users#not_participate', as: :not_participate
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "welcome#index"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :users, only: [:show]
    end
  end
end
