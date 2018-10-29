Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :transactions, only: [:index, :create]
end
