Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/', to: 'welcome#index'
  root to: 'welcome#index'
  # note Rails has a helper for the above "root" path: root to: 'welcome#index'
  # to see all routes and connections to controllers, run `rails routes` Rake task

  get '/dashboard' => 'dashboard#show', as: 'dashboard'

  get '/signup' => 'users#new', as: 'signup'
  get '/profile' => 'users#profile', as: 'profile'
  get '/login' => 'sessions#new', as: 'login'
  delete '/logout' => 'sessions#destroy', as: 'logout'

  resources :users, only: [:show, :create, :edit, :update] do
    resources :invitations, only: [:show, :create]
  end

  resources :groups do
    resources :lists do
      resources :items
    end
  end
  resources :sessions, except: [:edit, :update]
end
