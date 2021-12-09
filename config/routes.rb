Rails.application.routes.draw do
  get 'positions/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  resources :teams, only: [:index]
  resources :seasons, only: [:index]
  resources :competitions, only: [:index]
  resources :competseasons, only: [:index]
  resources :fixtures, only: [:index, :show]
  resources :players, only: [:index]
  resources :contracts, only: [:index]
  resources :selections, only: [:index]
  resources :positions, only: [:index]
end
