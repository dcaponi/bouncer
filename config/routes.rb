Rails.application.routes.draw do
  post '/tokens', to: 'tokens#access_token'
  
  get '/confirm_email/', :to => 'users#update', as: 'confirm_email'

  resources :users, except: [:destroy]
  get '/user', to: 'users#show'

  resources :policies, except: [:show, :update]
  put '/policies', to: 'policies#update'
end
