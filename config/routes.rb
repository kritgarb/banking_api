Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      resources :users, only: [:create]
      get 'conta/saldo', to: 'conta#saldo'
      post 'conta/deposito', to: 'conta#deposito'
      post 'transferencias', to: 'transferencias#create'
      post 'transferencias/agendada', to: 'transferencias#agendada'
      
      get 'extrato', to: 'extrato#index'
    end
  end
  
  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
