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
    resources :answers, concerns: [:rated] do
      patch :set_best
    end
  end

  resources :attachments, only: :destroy

end
