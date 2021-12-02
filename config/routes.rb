Rails.application.routes.draw do
  
  get 'fixtures/index'
  get 'fixtures/show'
  get 'competseasons/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  resources :teams, only: [:index]
  resources :seasons, only: [:index]
  resources :competitions, only: [:index]
  resources :competseasons, only: [:index]
end
