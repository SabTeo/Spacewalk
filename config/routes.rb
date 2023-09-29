Rails.application.routes.draw do
#  resources :articles
#  resources :article do
#    resources :comments
#  end
  root 'articles#index'
  get '/articles', to: 'articles#index'
  get '/articles/:id', to: 'articles#show', as: 'article'
  get '/articles/:id/comments', to: 'comments#index', as: 'comments'


  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
