Rails.application.routes.draw do
  resources :my_data, only: :index
  resources :my_updates, only: :create
end
