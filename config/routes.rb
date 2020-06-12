Rails.application.routes.draw do

  root to: 'homepages#index'
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_calback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  resources :merchants
  resources :products

  resources :orders

  # TODO: implement empty cart route
  # patch "orders/:id", to: "orders#empty_cart", as: "empty_cart"

  


  resources :products do
    resources :order_items, only: [:index, :new, :create]
  end
  
end

