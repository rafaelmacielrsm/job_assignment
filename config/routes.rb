Rails.application.routes.draw do
  namespace :api, constraints: {subdomain: 'api'}, path: '/' do
      resource :survivor, only: [:create, :update] do
        resource :trade, only: [:create]
        resource :infection_report, only: [:create]
      end
  end
end
