Rails.application.routes.draw do
#  resources :articles
#  resources :article do
#    resources :comments
#  end
  get '/articles', to: 'articles#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
