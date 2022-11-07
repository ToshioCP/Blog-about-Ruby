Rails.application.routes.draw do
  root "words#index"
  get "words/search"
  resources :words
end
