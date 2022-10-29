Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote
    end
  end

  resources :questions, shallow: true, concerns: :votable, defaults: { votable: 'questions' } do
    resources :comments, defaults: { commentable: 'questions' }, only: %i[create update destroy]
    
    resources :answers, shallow: true, concerns: :votable, defaults: { votable: 'answers' }
      resources :comments, defaults: { commentable: 'answers' }, only: %i[create update destroy]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show

  root to: 'questions#index'
end
