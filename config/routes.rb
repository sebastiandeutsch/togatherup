Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resource :session, only: %i[new create destroy]
  resources :registrations, only: %i[new create]
  resource :dashboard, only: :show, controller: "dashboards"
  resource :profile, only: %i[show edit update]
  resources :availability_slots, except: :show

  resources :groups do
    resources :events, module: :groups
    resources :group_invitations, only: %i[index create destroy], module: :groups
    delete "memberships/:id", to: "group_memberships#destroy", as: :membership
  end

  get "invites/:token", to: "group_invitations#show", as: :group_invitation
  post "invites/:token/accept", to: "group_invitations#accept", as: :accept_group_invitation

  resources :event_time_suggestions, only: [] do
    resource :vote, only: %i[create update], controller: "event_votes"
  end
end
