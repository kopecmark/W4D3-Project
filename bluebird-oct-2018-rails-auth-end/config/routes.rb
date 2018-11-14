Rails.application.routes.draw do
  # Seen before
    # get '/users/new', to: "users#new"
    # get '/users/:id', to: "users#show"
  # # Sort of new – Sign up
    # post '/users', to: "users#create"
  resources :users, only: [:new, :create, :show]

  # New – Login/Logout
    # get '/session', to: "session#new"
    # post '/session', to: "session#create"
    # delete '/session', to: "session#destroy"
  resource :session, only: [:new, :create, :destroy]
  # resource is singular here to denote that there is only one session (we don't have multiple session resources)
end
