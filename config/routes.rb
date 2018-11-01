Rails.application.routes.draw do
  get "stations" => "stations#index"
  get "stations/new" => "stations#new"
  get "stations/:id" => "stations#show"
  get "stations/:id/edit" => "stations#edit"
  post "stations" => "stations#create"
  #put "stations/:id" => "stations#update"
  post "stations/:id/pwr_cont" => "stations#pwr_cont"
  post "stations/:id/pwr_off" => "stations#pwr_off"
  post "stations/:id/btns" => "stations#btns" ,as: :stations_show
  post "stations/:id/change_power" => "stations#change_power"
  post "stations/:id/back_16" => "stations#back_16"
  post "stations/:id/menu" => "stations#menu"
  post "stations/:id/cancel" => "stations#cancel"
  post "stations/:id/off_btn" => "stations#off_btn"
  post "stations/:id/func" => "stations#func"
  post "stations/:id/dsc_rtn" => "stations#dsc_rtn"
  delete "stations/:id" => "stations#destroy"

  post "dscs/ship_station_call" => "dscs#ship_station_call"

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
