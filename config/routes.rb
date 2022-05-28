Rails.application.routes.draw do
  get 'events/index'
  get 'staging' => 'standalonepages#staging'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  resources :teams, only: [:index, :show, :edit, :update, :destroy]
  resources :seasons, only: [:index]
  resources :competitions, only: [:index]
  resources :competseasons, only: [:index]
  resources :fixtures, only: [:index, :show]
  resources :players, only: [:index, :show, :edit, :update, :destroy]
  resources :contracts, only: [:index]
  resources :selections, only: [:index, :edit, :update]
  resources :positions, only: [:index]
  resources :standalonepages, only: [:staging]
  resources :eventtypes, only: [:index]
  resources :events, only: [:index]
end
