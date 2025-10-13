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

      # Store
      get '/store/data'
      get '/store', to: 'store#index', as: 'store'
      get '/store/data', to: 'store#data'
      get '/store/:id/show', to: 'store#show', as: 'store_show'
      get '/store/new', to: 'store#new', as: 'store_new'
      post '/store', to: 'store#create', as: 'store_create'
      get '/store/:id/delete', to: 'store#destroy', as: 'store_delete'
      get '/store/:id/edit', to: 'store#edit', as: 'store_edit'
      put '/store/:id/update', to: 'store#update', as: 'store_update'
      post '/store/delete', to: 'store#destroy_block'

      # ProductItem
      get '/product_item/data'
      get '/product_item', to: 'product_item#index', as: 'product_item'
      get '/product_item/data', to: 'product_item#data'
      get '/product_item/:id/show', to: 'product_item#show', as: 'product_item_show'
      get '/product_item/new', to: 'product_item#new', as: 'product_item_new'
      post '/product_item', to: 'product_item#create', as: 'product_item_create'
      get '/product_item/:id/delete', to: 'product_item#destroy', as: 'product_item_delete'
      get '/product_item/:id/edit', to: 'product_item#edit', as: 'product_item_edit'
      put '/product_item/:id/update', to: 'product_item#update', as: 'product_item_update'
      post '/product_item/delete', to: 'product_item#destroy_block'

      # NomUnit
      get '/nom_unit/data'
      get '/nom_unit', to: 'nom_unit#index', as: 'nom_unit'
      get '/nom_unit/data', to: 'nom_unit#data'
      get '/nom_unit/:id/show', to: 'nom_unit#show', as: 'nom_unit_show'
      get '/nom_unit/new', to: 'nom_unit#new', as: 'nom_unit_new'
      post '/nom_unit', to: 'nom_unit#create', as: 'nom_unit_create'
      get '/nom_unit/:id/delete', to: 'nom_unit#destroy', as: 'nom_unit_delete'
      get '/nom_unit/:id/edit', to: 'nom_unit#edit', as: 'nom_unit_edit'
      put '/nom_unit/:id/update', to: 'nom_unit#update', as: 'nom_unit_update'
      post '/nom_unit/delete', to: 'nom_unit#destroy_block'

      # CostSheets
      get '/cost_sheet/data'
      get '/cost_sheet', to: 'cost_sheet#index', as: 'cost_sheet'
      get '/cost_sheet/data', to: 'cost_sheet#data'
      get '/cost_sheet/:id/show', to: 'cost_sheet#show', as: 'cost_sheet_show'
      get '/cost_sheet/new', to: 'cost_sheet#new', as: 'cost_sheet_new'
      post '/cost_sheet', to: 'cost_sheet#create', as: 'cost_sheet_create'
      get '/cost_sheet/:id/delete', to: 'cost_sheet#destroy', as: 'cost_sheet_delete'
      get '/cost_sheet/:id/edit', to: 'cost_sheet#edit', as: 'cost_sheet_edit'
      put '/cost_sheet/:id/update', to: 'cost_sheet#update', as: 'cost_sheet_update'
      post '/cost_sheet/delete', to: 'cost_sheet#destroy_block'
    end

    resources :favorites, only: [:index, :create, :destroy], param: :product_id
    resources :users, only: :show, path: '/user', param: :username
    resources :categories, except: :show
    resources :products # para k empiece en '/' es ",path: '/'"
  end
end
