Rails.application.routes.draw do
#  resources :articles
#  resources :article do
#     resources :comments
#  end

  root 'articles#index'
  get '/launches', to: 'pages#launches', as: 'launches'
  get '/articles', to: 'articles#index'
  get 'articles/new', to: 'articles#new', as: "new_article"
  post 'articles', to: 'articles#create'
  get '/articles/:id', to: 'articles#show', as: 'article'
  delete '/articles/:id', to: 'articles#destroy', as: 'delete_article'
  
  get '/articles/:id/comments', to: 'comments#index', as: 'comments'
  post '/articles/:id/comments', to: 'comments#create', as: 'new_comment'
  patch '/comments/:id', to: 'comments#update', as: 'edit_comment'
  put '/comments/:id', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy', as: 'delete_comment'

  get '/proposals', to: 'proposals#index'
  get 'proposals/new', to: 'proposals#new', as: "new_proposal"
  post 'proposals', to: 'proposals#create'
  get '/proposals/:id', to: 'proposals#show', as: 'proposal'
  patch 'proposals/:id', to: 'proposals#update', as: 'update_proposal'
  delete '/proposals/:id', to: 'proposals#destroy', as: 'delete_proposal'

  devise_for :users, :controllers => { registrations: 'users/registrations', 
                                      omniauth_callbacks: "users/omniauth_callbacks" }


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
