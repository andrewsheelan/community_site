Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  resources :chat_rooms do
    resources :messages, only: [ :create ]
  end

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    member do
      post :publish
      post :unpublish
    end
  end

  resources :events do
    resources :comments, only: [ :create, :destroy ]
    collection do
      get :calendar
      get :upcoming
      get :past
    end
    member do
      post :join
      delete :leave
    end
  end

  # Community routes
  get "community", to: "community#index"
  post "community/start_chat", to: "community#start_chat", as: :start_chat_community

  # User profile and dashboard routes
  get "dashboard", to: "dashboard#index"
  get "profile", to: "users#profile"
  get "settings", to: "users#settings"

  # Mount Action Cable
  mount ActionCable.server => "/cable"
end
