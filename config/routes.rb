Rails.application.routes.draw do  
  root 'welcome#index'

  namespace :api do
    resources :agendas, only: [:index, :show]
    resources :items, only: [:index, :show]
    resources :wards, only: [:index, :show]
    resources :councillors, only: [:index, :show]
    resources :committees, only: [:index, :show]
    resources :motions, only: [:index, :show]
    resources :docs, only: [:index]
  end

  resources :users do
    resources :user_votes, only: [:index]
  end

  resources :items, only: [:index, :show, :edit, :update] do
    resources :user_votes, only: [:new, :create]
  end

  resources :councillors, only: [:index, :show]
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :dirty_agenda, only: [:index, :show]

  get 'welcome/index' => 'welcome#index', :as => :welcome
  get 'api/docs'      => 'api#index', :as => :docs
  get 'signup'        => 'users#new', :as => :signup
  get 'myprofile'     => 'users#show', :as => :myprofile
  get 'myvotes'       => 'user_votes#index', :as => :myvotes
  get 'login'         => 'user_sessions#new', :as => :login
  post 'logout'       => 'user_sessions#destroy', :as => :logout

end
