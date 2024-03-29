require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do  
    mount Sidekiq::Web => '/sidekiq'
  end
  
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
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, shallow: true, concerns: :votable, defaults: { votable: 'answers' } do
      resources :comments, defaults: { commentable: 'answers' }, only: %i[create update destroy]
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show

  root to: 'questions#index'
  get 'search', to: 'search#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end
end
