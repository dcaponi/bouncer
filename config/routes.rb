Rails.application.routes.draw do
  post "/tokens", to: 'tokens#access_token'
  post "/test", to: 'tokens#test'
  resources :users
end
