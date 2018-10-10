Rails.application.routes.draw do
  resources :users
  get "/" => "home#top"
  get "about" => "home#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "users" => "users#index"
  get "users/:id" => "users#show"
  get "signup" => "users#new"
  post "users" => "users#create"
  get "users/:id/edit" => "users#edit"
  put "users/:id" => "users#update"
  delete "users/:id" => "users#destroy"
end
