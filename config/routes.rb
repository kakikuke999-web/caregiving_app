Rails.application.routes.draw do
  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "home#index"  # 仮のトップページ

  post "show_menu", to: "home#show_menu"

  get "dashboard", to: "dashboard#index"
  get "calendar", to: "calendar#index"
  get "calendar_events", to: "visit_reports#calendar_events_all"
  get "personal_schedule_events", to: "personal_schedules#calendar_events_all"

  resources :care_recipients do
    member do
      get :calendar  # ← 名前付きルートは `calendar_care_recipient_path`
      get :visit_events, to: 'visit_reports#calendar_events', as: :visit_events  # ← 名前付きルートは `visit_events_care_recipient_path`
      get :personal_schedule_events, to: 'personal_schedules#calendar_events', as: :personal_schedule_events
    end

    resources :family_memberships, only: [:create, :destroy]
    resources :vitals
    resources :adl_records
    resources :medication_records
    resources :emergency_contacts, except: [:index, :show]
    resources :personal_schedules, except: [:index, :show]
  end

  resources :visit_reports do
    resources :comments, only: [:create, :destroy]
  end
  resources :visit_types, except: [:show]
  resources :users, only: [:index, :edit, :update]
end
