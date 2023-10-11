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
  put '/articles/:id', to: 'articles#update', as: 'update_article'
  get '/proposal', to: 'articles#proposal'
  delete 'articles/:id', to: 'articles#destroy'
  get '/articles/:id/comments', to: 'comments#index', as: 'comments'
  post '/articles/:id/comments', to: 'comments#create', as: 'new_comment'
  patch '/comments/:id', to: 'comments#update', as: 'edit_comment'
  put '/comments/:id', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy', as: 'delete_comment'

  devise_for :users, :controllers => { registrations: 'users/registrations', 
                                      omniauth_callbacks: "users/omniauth_callbacks" }


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
