Rails.application.routes.draw do
  devise_for :users
  root 'transactions#index'
end
