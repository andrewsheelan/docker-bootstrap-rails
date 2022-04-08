require 'sidekiq/web'

Rails.application.routes.draw do
    # Active admin UI /admin
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Sidekiq admin ui /sidekiq
    mount Sidekiq::Web => '/sidekiq'
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
    # Swagger Docs /swagger
    mount Rswag::Api::Engine => 'api-docs'
    mount Rswag::Ui::Engine => 'swagger'

    # Defines the root path route ("/")
    root to: redirect('/admin')
  end