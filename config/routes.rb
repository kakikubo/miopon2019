# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'

  get 'pages/mio_config'
  get 'pages/callback'
  get 'pages/register'
  post 'pages/register'
  post 'pages/mio_update_user'
  post 'pages/mio_update'
  get 'pages/mio_data'
  get 'pages/user_info'
  get 'pages/user_info', as: 'user_root'
  root 'pages#user_info'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get '*path', controller: 'application', action: 'render_404'
end
