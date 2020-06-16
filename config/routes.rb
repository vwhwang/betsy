Rails.application.routes.draw do
  root to: "homepages#index"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_calback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  resources :merchants

  resources :products
  resources :categories, only: [:show]

  resources :orders

  resources :order_items
  get "/orders/:id/status", to: "orders#status", as: "status"
  # TODO: implement empty cart route
  # patch "orders/:id", to: "orders#empty_cart", as: "empty_cart"

  patch "/product/:id/retire", to: "products#retire", as: "retire_product"
  resources :products do
    resources :order_items, only: [:index, :new, :create]
    resources :reviews, only: [:new, :create]
  end

  resources :orders do
    resources :order_items, only: [:update]
  end

end
