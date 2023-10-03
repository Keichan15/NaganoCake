Rails.application.routes.draw do

  # 顧客用
  # URL /customers/..
  root to: "public/homes#top"
  resource :customers, only: [:edit, :update], module: 'public'
  resources :items, only: [:index, :show], module: 'public'
  delete 'cart_items/destroy_all' => "public/cart_items#destroy_all"

  resources :cart_items, only: [:index, :update, :destroy, :create], module: 'public'
  resources :addresses, only: [:index, :edit, :create, :update, :destroy], module: 'public'

  post 'orders/confirm' => "public/orders#confirm"
  get 'orders/complete' => "public/orders#complete"
  resources :orders, only: [:new, :create, :index, :show], module: 'public'

  get 'customers/my_page' => "public/customers#show"
  get 'customers/unsubscribe' => "public/customers#unsubscribe"
  patch 'customers/withdraw' => "public/customers#withdraw"

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }


  # 管理者用
  # URL /admin/...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get '/' => 'homes#top'
    resources :customers, only: [:index]
    resources :items, only: [:index, :new, :create, :show, :edit, :update] do
      collection do
        get 'search'
      end
    end
    resources :genres, only: [:index, :create, :edit, :update]
    resources :orders, only: [:index, :show, :update] do
      resources :order_details, only: [:update]
    end

  end

end
