Store::Application.routes.draw do
  devise_for :users

  resources :products

  root :to => "home#index"
end
