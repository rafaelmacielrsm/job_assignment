Rails.application.routes.draw do
  namespace :api,
    defaults: { format: :json },
    constraints: {subdomain: 'api'},
    path: '/' do
      resource :survivor, only: [:create]
  end
end
