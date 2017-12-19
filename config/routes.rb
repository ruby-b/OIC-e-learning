Rails.application.routes.draw do
  devise_for :users
  resources :tags, except: :show
  resources :books
  resources :products, only: [:index, :show]
  resources :orders, only: [:new, :create] do
    collection do
      post :confirm
    end
  end
  root 'products#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
