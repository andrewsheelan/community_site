Rails.application.routes.draw do
  # Authentication routes
  devise_for :users
  
  # Chat routes
  resource :chat, only: [:show, :create]
  post '/messages', to: 'chats#create', as: :messages
  
  # User routes
  resources :users, only: [:index]
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Set root path
  root 'home#index'
end
