Rails.application.routes.draw do
  post "/tokens", to: 'tokens#access_token'
  get '/confirm_email/', :to => "users#update", as: 'confirm_email'
  resources :users
end
