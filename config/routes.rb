Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

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

  mount ActionCable.server => "/cable"
end
