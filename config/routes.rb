Rails.application.routes.draw do
  namespace :api, constraints: {subdomain: 'api'}, path: '/' do
      resource :survivor, only: [:create, :update]
  end
end
