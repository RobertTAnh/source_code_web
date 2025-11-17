Admin::Engine.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'admin/omniauth_callbacks'
  }
  root :to => 'products#index'

  resources :products do
    member do
      get :albums
    end
  end

  resources :posts do
    member do
      get :albums
    end
  end

  resources :pages do
    member do
      get :albums
    end
  end

  resources :homes

  resources :categories do
    member do
      get :albums
    end
  end

  resources :comments, only: %i(index create update show) do
    member do
      post :reply
    end
  end

  resources :global_slugs
  resources :users
  resources :contacts
  resources :orders
  resources :albums
  resource :dashboard, controller: 'dashboard', only: %i(show)
  resource :page_contents
  resources :variants, only: %i(update destroy)

  WebConfig.custom_resource_config.each do |resource_config|
    resources resource_config[:name].underscore.pluralize.to_sym
  end

  get 'web_configs', to: 'web_configs#edit'
  patch 'web_configs', to: 'web_configs#update'
  get 'advanced_settings', to: 'web_configs#advanced_settings'
  patch 'advanced_settings', to: 'web_configs#update_advanced_settings'
  post 'medias/upload', to: 'medias#upload'
  get 'medias/browse', to: 'medias#browse'
  delete 'medias/files/*key', to: 'medias#destroy'
end
