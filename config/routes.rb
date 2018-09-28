Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/', to: 'welcome#index'
  root to: 'welcome#index'
  # note Rails has a helper for the above "root" path: root to: 'welcome#index'
  # to see all routes and connections to controllers, run `rails routes` Rake task

  get '/dashboard' => 'dashboard#show', as: 'dashboard'

  get '/signup' => 'users#new', as: 'signup'
  get '/profile(/:id)' => 'users#show', as: 'profile'
  # get '/profile/:id', to: 'users#show', as: 'profile/:id'
  get '/login' => 'sessions#new', as: 'login'
  delete '/logout' => 'sessions#destroy', as: 'logout'

  resources :users, only: [:create, :edit]
  resources :groups

  resources :sessions, except: [:edit, :update]
end
