Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  root 'static_pages#index'
  resources :portfolio, only: [:index]
  post '/portfolio/refresh', to: 'portfolio#refresh'
  post '/portfolio/modal', to: 'portfolio#modal'
  resources :transactions, only: [:index, :create]
end
