Rails.application.routes.draw do

  root to: 'articles#index'
  get '/launches', to: 'pages#launches', as: 'launches'
  get '/articles', to: 'articles#index'
  get 'articles/new', to: 'articles#new', as: "new_article"
  post 'articles', to: 'articles#create'
  get '/articles/:id', to: 'articles#show', as: 'article'
  delete '/articles/:id', to: 'articles#destroy', as: 'delete_article'
  
  get '/articles/:id/comments', to: 'comments#index', as: 'comments'
  post '/articles/:id/comments', to: 'comments#create', as: 'new_comment'
  patch '/articles/:art_id/comments/:id', to: 'comments#update', as: 'edit_comment'
  put '/articles/:art_id/comments/:id', to: 'comments#update'
  delete '/articles/:art_id/comments/:id', to: 'comments#destroy', as: 'delete_comment'

  get '/proposals', to: 'proposals#index'
  get 'proposals/new', to: 'proposals#new', as: "new_proposal"
  post 'proposals', to: 'proposals#create'
  get '/proposals/:id', to: 'proposals#show', as: 'proposal'
  patch 'proposals/:id', to: 'proposals#update', as: 'update_proposal'
  delete '/proposals/:id', to: 'proposals#destroy', as: 'delete_proposal'

  delete '/users', to: 'application#redirect_home' #override devise delete user

  devise_for :users, :controllers => { registrations: 'users/registrations', 
                                      omniauth_callbacks: "users/omniauth_callbacks"
                                     }
  post '/user/:id/edit', to: 'user#edit_profile', as: 'edit_profile'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
