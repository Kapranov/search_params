Rails.application.routes.draw do

  root to: 'books#index'

  # match '/list/books', to: 'books#index', via: :get

  get 'lists/books'

  resources :books, only: [:index, :show] do
    get 'search', on: :collection
  end

  resources :articles, only: [:index, :show] do
    get 'search', on: :collection
  end
end
