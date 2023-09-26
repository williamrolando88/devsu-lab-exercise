Rails.application.routes.draw do
  root 'bookshelf#index'
  resources :books
  resources :authors
end
