Rails.application.routes.draw do
  root 'sessions#new'
  get 'welcome', to: 'pages#welcome'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
end
