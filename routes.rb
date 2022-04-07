require 'sidekiq/web'

Rails.application.routes.draw do
    # Active admin UI
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Sidekiq admin ui
    mount Sidekiq::Web => '/sidekiq'
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
    # Defines the root path route ("/")
    # root "profiles#index"
  end