Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/', to: 'welcome#index'
  root to: 'welcome#index'
  get '/react' => 'react#index'

  namespace :api, defaults: { format: 'json' } do
    post 'authenticate' => 'auth#authenticate'
   namespace :v1 do
     get '/dashboard' => 'dashboard#show', as: 'dashboard'

     get '/signup' => 'users#new', as: 'signup'
     get '/profile' => 'users#profile', as: 'profile'
     get '/login' => 'sessions#new', as: 'login'
     delete '/logout' => 'sessions#destroy', as: 'logout'

     resources :users, only: [:show, :create, :edit, :update] do
       resources :invitations, only: [:create]
     end
     get '/accept/:id' => 'invitations#accept', as: 'accept'
     get '/decline/:id' => 'invitations#decline', as: 'decline'

     resources :groups, except: [:index] do
       post '/invite' => 'invitations#invite', as: 'invite'
       post '/assign-santa' => 'santa_assignments#assign', as: '/assign-santa'
       resources :exclusion_teams, only: [:create, :edit, :update, :destroy], path: 'teams' do
         resources :user_exclusion_teams, only: [:destroy], path: 'user'
       end
       resources :user_exclusion_teams, only: [:create]
       get '/wishlists/:id/new', to: 'lists#new'
       resources :lists, except: [:new, :index], path: 'wishlists' do
         resources :items, except: [:new]
       end
     end
     resources :sessions, except: [:edit, :update]
   end
 end
  # note Rails has a helper for the above "root" path: root to: 'welcome#index'
  # to see all routes and connections to controllers, run `rails routes` Rake task

  get '/dashboard' => 'dashboard#show', as: 'dashboard'

  get '/signup' => 'users#new', as: 'signup'
  get '/profile' => 'users#profile', as: 'profile'
  get '/login' => 'sessions#new', as: 'login'
  delete '/logout' => 'sessions#destroy', as: 'logout'

  resources :users, only: [:show, :create, :edit, :update] do
    resources :invitations, only: [:create]
  end
  get '/accept/:id' => 'invitations#accept', as: 'accept'
  get '/decline/:id' => 'invitations#decline', as: 'decline'

  resources :groups, except: [:index] do
    post '/invite' => 'invitations#invite', as: 'invite'
    post '/assign-santa' => 'santa_assignments#assign', as: '/assign-santa'
    resources :exclusion_teams, only: [:create, :edit, :update, :destroy], path: 'teams' do
      resources :user_exclusion_teams, only: [:destroy], path: 'user'
    end
    resources :user_exclusion_teams, only: [:create]
    get '/wishlists/:id/new', to: 'lists#new'
    resources :lists, except: [:new, :index], path: 'wishlists' do
      resources :items, except: [:new]
    end
  end
  resources :sessions, except: [:edit, :update]
end
