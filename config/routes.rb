Rails.application.routes.draw do
  root 'sessions#new'
  get 'map', to: 'map#show'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :locations, only: [:create]
end
