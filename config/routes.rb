Rails.application.routes.draw do

  resources :workouts
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :user, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    member do
      patch :buy_pack
      get :buy_pack
      get :workout
      post :workout
      patch :use_makeup
    end
  end
  root 'users#index'
  get 'home/show'
  resources :trainingsessions
  resources :packages
  resources :workouts
  resources :microposts, path: 'history'
  get '/oauth2callback' => 'oauth2#oauth2callback'

end
