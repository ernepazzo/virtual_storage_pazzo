Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    # Rutas personalizadas para login/logout
    devise_scope :user do
      get    '/login',  to: 'devise/sessions#new',     as: :login
      post   '/login',  to: 'devise/sessions#create'
      delete '/logout', to: 'devise/sessions#destroy', as: :logout
      get    '/register', to: 'devise/registrations#new', as: :register
      post   '/register', to: 'devise/registrations#create'
      get    '/profile/edit', to: 'devise/registrations#edit', as: :edit_profile
      put    '/profile', to: 'devise/registrations#update'
      patch  '/profile', to: 'devise/registrations#update'
      delete '/profile', to: 'devise/registrations#destroy'
    end

    # Resto de rutas Devise normales (/users/...)
    devise_for :users


    root 'products#index'
    # namespace :authentication, path: '', as: '' do
    #   resources :users, only: [:new, :create], path: '/register', path_names: { new: '/' }
    #   resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/' }
    # end

    namespace :admin, path: :admin do
      get '/', to: 'admin#index'

      get '/users', to: 'users#index', as: 'users'
      get '/users/data', to: 'users#data', as: 'users_data'
      get '/users/:id/perfil', to: 'users#show', as: 'user_show'
      get '/users/:id/edit', to: 'users#edit', as: 'users_edit'
      post '/users/:id/update', to: 'users#update', as: 'users_update'

      # Entity Business
      get '/entity_business/data'
      get '/entity_business', to: 'entity_business#index', as: 'entity_business'
      get '/entity_business/data', to: 'entity_business#data'
      get '/entity_business/:id/show', to: 'entity_business#show', as: 'entity_business_show'
      get '/entity_business/new', to: 'entity_business#new', as: 'entity_business_new'
      post '/entity_business', to: 'entity_business#create', as: 'entity_business_create'
      get '/entity_business/:id/delete', to: 'entity_business#destroy', as: 'entity_business_delete'
      get '/entity_business/:id/edit', to: 'entity_business#edit', as: 'entity_business_edit'
      put '/entity_business/:id/update', to: 'entity_business#update', as: 'entity_business_update'
      post '/entity_business/delete', to: 'entity_business#destroy_block'

      # Warehouse
      get '/warehouse/data'
      get '/warehouse', to: 'warehouse#index', as: 'warehouse'
      get '/warehouse/data', to: 'warehouse#data'
      get '/warehouse/:id/show', to: 'warehouse#show', as: 'warehouse_show'
      get '/warehouse/new', to: 'warehouse#new', as: 'warehouse_new'
      post '/warehouse', to: 'warehouse#create', as: 'warehouse_create'
      get '/warehouse/:id/delete', to: 'warehouse#destroy', as: 'warehouse_delete'
      get '/warehouse/:id/edit', to: 'warehouse#edit', as: 'warehouse_edit'
      put '/warehouse/:id/update', to: 'warehouse#update', as: 'warehouse_update'
      post '/warehouse/delete', to: 'warehouse#destroy_block'
    end

    resources :favorites, only: [:index, :create, :destroy], param: :product_id
    resources :users, only: :show, path: '/user', param: :username
    resources :categories, except: :show
    resources :products # para k empiece en '/' es ",path: '/'"
  end
end
