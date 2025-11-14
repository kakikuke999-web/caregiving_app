Rails.application.routes.draw do
  get 'users/index'
  get 'users/edit'
  get 'users/update'
  get 'visit_reports/index'
  get 'visit_reports/show'
  get 'visit_reports/new'
  get 'visit_reports/edit'
  get 'care_recipients/index'
  get 'care_recipients/show'
  get 'care_recipients/new'
  get 'care_recipients/edit'
  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root to: "home#index"  # 仮のトップページ

  resources :care_recipients
  resources :visit_reports
  post "show_menu", to: "home#show_menu"
  resources :users, only: [:index, :edit, :update]

  get 'visit_events', to: 'visit_reports#calendar_events'

  resources :care_recipients do
    member do
      get :calendar  # ← 名前付きルートは `calendar_care_recipient_path`
      get :visit_events, to: 'visit_reports#calendar_events', as: :visit_events  # ← 名前付きルートは `visit_events_care_recipient_path`
    end
  end

end
