Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', 
                                    registrations: 'users/registrations' }
  concern :votable do
    member do
      post :vote
    end
  end

  resources :questions, shallow: true, concerns: :votable, defaults: { votable: 'questions' } do
    resources :comments, defaults: { commentable: 'questions' }, only: %i[create update destroy]
    
    resources :answers, shallow: true, concerns: :votable, defaults: { votable: 'answers' } do
      resources :comments, defaults: { commentable: 'answers' }, only: %i[create update destroy]
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index]
    end
  end
end
