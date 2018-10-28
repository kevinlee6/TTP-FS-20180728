Rails.application.routes.draw do
  devise_for :users
  root 'portfolio#show'
  resources :transactions, only: [:index, :create]
end
