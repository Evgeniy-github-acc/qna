Rails.application.routes.draw do
  devise_for :users
  #resources :questions do
  #  resources :answers, shallow: true 
  #end

  concern :votable do
    member do
      post :vote
    end
  end

  resources :questions, concerns: :votable, defaults: { votable: 'questions' } do
    resources :answers, shallow: true, concerns: :votable, defaults: { votable: 'answers' }
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show

  root to: 'questions#index'
end
