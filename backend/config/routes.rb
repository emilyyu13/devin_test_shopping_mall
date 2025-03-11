Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'login', to: 'authentication#login'
      
      # Products
      resources :products
      
      # Users
      resources :users, only: [:create, :show, :update] do
        resources :shipping_addresses
      end
      
      # Orders
      resources :orders, only: [:index, :show, :create, :update] do
        resources :order_items, only: [:create, :update, :destroy]
        resources :payments, only: [:create, :show]
        resources :shipments, only: [:create, :show, :update]
      end
    end
  end
end
