Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :rated do
    member do
      patch :rate
      patch :cancel_rate
    end
  end

  concern :commented do
    member do
      patch :comment
    end
  end

  resources :questions, concerns: [:rated, :commented] do
    resources :answers do
      patch :set_best
    end
  end

  resources :answers, concerns: [:rated, :commented], only: [:rate, :cancel_rate]

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"
end
