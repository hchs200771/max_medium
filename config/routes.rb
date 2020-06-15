Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'pages#index'

  get '/demo', to: 'pages#demo'
  # /@maxharry/文章標題
  get '@:user_name/:story_id', to: 'pages#show', as: :story_page
  # /@maxharry/   顯示該作者的所有文章
  get '@:user_name', to: 'pages#user', as: :user_page

  resources :stories

  resources :stories do
    resources :comments, only: [:create]
  end
end
