Rails.application.routes.draw do
  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "home#index"  # 仮のトップページ

  match "show_menu", to: "home#show_menu", via: [:get, :post]

  get "dashboard", to: "dashboard#index"
  post "alert_notifications/trigger", to: "alert_notifications#trigger"
  post "alert_notifications/send_test", to: "alert_notifications#send_test"
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
    resources :daily_reports, only: [:new, :create]
    resources :daily_report_imports, only: [:new, :create]
    resources :care_documents, except: [:show]
    resources :support_logs, except: [:show]
    resource :service_usage_slip, only: [:show]
    resources :care_plans
    resources :recurring_schedules, except: [:show] do
      post :generate, on: :collection
    end
  end

  resources :visit_reports do
    resources :comments, only: [:create, :destroy]
  end
  resources :visit_types, except: [:show]
  resources :users, only: [:index, :edit, :update]
end
