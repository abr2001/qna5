Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers do
      get :set_best
    end
  end

  resources :attachments, only: :destroy

end
