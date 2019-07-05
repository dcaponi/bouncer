Rails.application.routes.draw do
  post "/tokens", to: 'tokens#access_token'
  resources :users
end
