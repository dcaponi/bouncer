Rails.application.routes.draw do
  post '/tokens', to: 'tokens#access_token'

  get '/confirm_email/', :to => 'users#update', as: 'confirm_email'

  resources :users, except: [:destroy, :update]
  get '/user', to: 'users#show'
  put '/user', to: 'users#update'

  resources :policies, except: [:show, :update]
  put '/policies', to: 'policies#update'
end
