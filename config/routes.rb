require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  concern :rated do
    member do
      patch :rate
      patch :cancel_rate
    end
  end

  resources :questions, concerns: [:rated], shallow: true do
    resources :comments, defaults: {commentable: 'questions'}, only: [:create]
    resources :answers, shallow: true do
      resources :comments, defaults: {commentable: 'answers'}, only: [:create]
      patch :set_best
    end
  end

  resources :answers, concerns: [:rated], only: [:rate, :cancel_rate]

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end
  resources :subscriptions, only: [:create, :destroy]
  get '/search' => 'search#search'
  mount ActionCable.server => "/cable"
end
