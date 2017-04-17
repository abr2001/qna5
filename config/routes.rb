Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :rated do
    member do
      patch :rate
      patch :cancel_rate
    end
  end

  resources :questions, concerns: [:rated] do
    resources :answers do
      patch :set_best
    end
  end

  resources :answers, concerns: [:rated], only: [:rate, :cancel_rate]

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"
end
