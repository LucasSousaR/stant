Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq/cron/web"
  mount Sidekiq::Web => "/sidekiq"
  root "home#index"
  resources :tracks
  resources :integrations
  resources :speeches
  resources :home
  post "speeches/:id/destroy", to: "speeches#destroy"


  post "tracks/set_up_the_track", to: "tracks#set_up_the_track"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
