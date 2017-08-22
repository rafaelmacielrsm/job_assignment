Rails.application.routes.draw do
  namespace :api, constraints: {subdomain: 'api'}, path: '/' do
      resources :survivors, only: [:create, :update] do
        resources :trades, only: [:create]
        resources :infection_reports, only: [:create]
      end
      resources :reports, only: [:index] do
        collection do
          get 'infected'
          get 'non_infected'
          get 'inventories_overview'
          get 'resources_lost'
        end
      end
  end
end
