Rails.application.routes.draw do

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'standalonepages/landing'
  root to: 'standalonepages#landing'
  get 'staging' => 'standalonepages#staging'
  get 'layout' => 'standalonepages#layout'
  get 'admin' => 'standalonepages#admin'
  resources :teams, only: [:index, :show, :edit, :update, :destroy]
  resources :seasons, only: [:index]
  resources :competitions, only: [:index]
  resources :competseasons, only: [:index]
  resources :fixtures, only: [:index, :show]
  resources :players, only: [:index, :show, :edit, :update, :destroy]
  resources :contracts, only: [:index]
  resources :selections, only: [:index, :edit, :update]
  resources :positions, only: [:index]
  resources :eventtypes, only: [:index]

  # resources :events, only: [:index]
  resources :events do
    get 'events' => 'events#index'
    collection do 
      get 'registered' => 'events#registered'
      get 'unregistered' => 'events#unregistered'
    end
  end

end
