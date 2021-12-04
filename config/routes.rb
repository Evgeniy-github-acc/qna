Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true 
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show

  root to: 'questions#index'
end
