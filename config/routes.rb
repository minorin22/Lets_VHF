Rails.application.routes.draw do
  get "stations" => "stations#index"
  get "stations/new" => "stations#new"
  get "stations/:id" => "stations#show"
  get "stations/:id/edit" => "stations#edit"
  post "stations" => "stations#create"
  #put "stations/:id" => "stations#update"
  post "stations/:id/back_16" => "stations#back_16"
  delete "stations/:id" => "stations#destroy"

  #resources :users
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

  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
end
