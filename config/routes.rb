Rails.application.routes.draw do
#  resources :articles
#  resources :article do
#    resources :comments
#  end
  root 'articles#index'
  get '/launches', to: 'pages#launches', as: 'launches'
  get '/articles', to: 'articles#index'
  get '/articles/:id', to: 'articles#show', as: 'article'
  get '/articles/:id/comments', to: 'comments#index', as: 'comments'
  post '/article/:id/comments', to: 'comments#create', as: 'new_comment'

  devise_for :users, :controllers => { registrations: 'users/registrations' }


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
