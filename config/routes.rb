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
  get 'vip/kits' => 'standalonepages#vipkits'
  get 'vip/tags' => 'standalonepages#viptags'

  resources :teams, only: [:index, :show, :edit, :update, :destroy]
  resources :fixtures, only: [:show, :destroy, :update, :edit]
  resources :players, only: [:show, :edit, :update, :destroy]
  resources :selections, only: [:edit, :update]
  resources :kits, only: [:edit, :update]
  resources :tags, only: [:index, :edit, :new, :update, :create, :destroy]

  resources :events do
    resources :eventtags, only: [:new, :create]
    collection do 
      get 'registered' => 'events#registered'
      get 'unregistered' => 'events#unregistered'
    end
  end

end
