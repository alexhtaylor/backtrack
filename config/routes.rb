Rails.application.routes.draw do
  root 'sessions#new'
  get 'map', to: 'map#show'
  get 'locations', to: 'locations#show'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  patch 'toggle_location_visibility', to: 'locations#toggle_location_visibility'
  post 'request_friend', to: 'map#request_friend', as: 'request_friend'
  post 'accept_friend', to: 'map#accept_friend', as: 'accept_friend'
  post 'reject_friend', to: 'map#reject_friend', as: 'reject_friend'

  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :locations, only: [:create]
end
