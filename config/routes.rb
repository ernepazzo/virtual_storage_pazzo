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
    end

    resources :favorites, only: [:index, :create, :destroy], param: :product_id
    resources :users, only: :show, path: '/user', param: :username
    resources :categories, except: :show
    resources :products # para k empiece en '/' es ",path: '/'"
  end
end
