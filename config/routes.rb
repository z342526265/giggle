Giggle::Application.routes.draw do
  get "evaluates/index"
  get "evaluates/show"
  get "evaluates/new"
  get "evaluates/edit"
  get '/sign-in', to: 'sessions#new', as: :user_sign_in
  delete '/sign-out', to: 'sessions#destroy', as: :user_sign_out
  resources :sessions, only: :create

  namespace :admin do
    root 'products#index'
    resources :products
    resources :messages
    resources :users
    resources :product_categories
    resources :evaluates
    
  end
 
  resources :admins
  match '/signup', to: 'admins#new', via: 'get'

  resources :products, only: [:index, :show]

  root 'products#index'
end
