Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/', to: 'welcome#index'
  root to: 'welcome#index'
  # note Rails has a helper for the above "root" path: root to: 'welcome#index'
  # to see all routes and connections to controllers, run `rails routes` Rake task

  get '/new', to: 'users#new', as: 'signup'

  resources :users
  resources :sessions
end
