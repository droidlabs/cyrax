Store::Application.routes.draw do
  devise_for :users

  resources :products

  namespace :api do
    resources :products
  end

  root :to => "home#index"
end
