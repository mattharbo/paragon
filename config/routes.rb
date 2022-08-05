Rails.application.routes.draw do

  
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  get 'staging' => 'standalonepages#staging'
  get 'layout' => 'standalonepages#layout'
  get 'vip' => 'standalonepages#vip'
  get 'vip/competitions' => 'standalonepages#vipcompetitions'
  get 'vip/seasons' => 'standalonepages#vipseasons'
  get 'vip/exercises' => 'standalonepages#vipcompetseasons'
  get 'vip/teams' => 'standalonepages#vipteams'
  get 'vip/players' => 'standalonepages#vipplayers'
  get 'vip/contracts' => 'standalonepages#vipcontracts'
  get 'vip/fixtures' => 'standalonepages#vipfixtures'
  get 'vip/selections' => 'standalonepages#vipselections'
  get 'vip/events' => 'standalonepages#vipevents'
  get 'vip/positions' => 'standalonepages#vippositions'
  get 'vip/eventtypes' => 'standalonepages#vipeventtypes'


  resources :teams, only: [:index, :show, :edit, :update, :destroy]
  # resources :seasons, only: [:index]
  # resources :competitions, only: [:index]
  # resources :competseasons, only: [:index]
  # resources :fixtures, only: [:index, :show]
  resources :fixtures, only: [:show]
  # resources :players, only: [:index, :show, :edit, :update, :destroy]
  resources :players, only: [:show, :edit, :update, :destroy]
  # resources :contracts, only: [:index]
  # resources :selections, only: [:index, :edit, :update]
  resources :selections, only: [:edit, :update]
  # resources :positions, only: [:index]
  # resources :eventtypes, only: [:index]

  # resources :events, only: [:index]
  resources :events do
    get 'events' => 'events#index'
    collection do 
      get 'registered' => 'events#registered'
      get 'unregistered' => 'events#unregistered'
    end
  end

end
