Rails.application.routes.draw do
  namespace :api, constraints: {subdomain: 'api'}, path: '/' do
      resource :survivor, only: [:create, :update]
      resource :infection_report, only: [:create]
      resource :trade, only: [:create]
  end
end
