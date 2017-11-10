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

  resources :questions, concerns: [:rated], concerns: [:commented] do
    resources :answers do
      patch :set_best
    end
  end

  resources :answers, concerns: [:rated], only: [:rate, :cancel_rate], concerns: [:commented]

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"
end
