Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/', to: 'welcome#index'
  root to: 'welcome#index'
  # note Rails has a helper for the above "root" path: root to: 'welcome#index'
  # to see all routes and connections to controllers, run `rails routes` Rake task

  get '/signup' => 'users#new', as: 'signup'
  get '/profile' => 'users#show', as: 'profile'
  get '/login' => 'sessions#new', as: 'login'
  delete '/logout' => 'sessions#destroy', as: 'logout'

  resources :users, only: [:new, :create, :show]
  resources :sessions, except: [:edit, :update]
end
