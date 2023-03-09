Rails.application.routes.draw do
  root 'sessions#new'
  get 'map', to: 'map#show'
  get 'locations', to: 'locations#show'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  patch 'toggle_location_visibility', to: 'locations#toggle_location_visibility'

  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :locations, only: [:create]
end
