Rails.application.routes.draw do
  
  get 'competitions/index'
  get 'seasons/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  resources :teams, only: [:index]
  resources :seasons, only: [:index]
  resources :competitions, only: [:index]
end
