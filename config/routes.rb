Rails.application.routes.draw do
  post 'sign-in', to: 'sessions#authenticate', as: 'sessions_authenticate'
  post 'sign-out', to: 'sessions#sign_out', as: 'sessions_sign_out'
  get 'verify-token', to: 'sessions#verify_token', as: 'sessions_verify_token'

  resources :users
  resources :sessions, only: [:index]

  root :to => 'index#index'
end
