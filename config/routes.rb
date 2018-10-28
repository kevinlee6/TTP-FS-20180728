Rails.application.routes.draw do
  devise_for :users
  root 'transactions#index'
  get :portfolio, to: 'portfolio#show'
  resources :transactions, only: [:index, :create]
end
