Rails.application.routes.draw do
  root 'sessions#new'
  get 'map', to: 'map#show'
  get 'locations', to: 'locations#show'
  get 'sessions/new'
  get '/sessions', to: redirect('/')
  get '/users', to: redirect('/')
  get 'sessions/create'
  get 'sessions/destroy'
  get '/images/show', to: 'images#show', as: 'image_proxy'
  patch 'toggle_location_visibility', to: 'locations#toggle_location_visibility'
  post 'request_friend', to: 'map#request_friend', as: 'request_friend'
  post 'accept_friend', to: 'map#accept_friend', as: 'accept_friend'
  post 'reject_friend', to: 'map#reject_friend', as: 'reject_friend'
  get '*path', to: 'errors#not_found', via: :all
  # match '*unmatched', to: 'errors#not_found', via: :all

  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :locations, only: [:create]
end
