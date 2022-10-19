Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        member { resources :answers, only: [:create] }
      end
      resources :answers, only: [:show, :update, :destroy]
    end
  end

  concern :votable do
    patch :add_points
    patch :low_points
  end
  concern :commentable do
    resources :commentable
  end
  resources :questions do
    resources :answers,
              shallow: true,
              only: [:create, :update, :destroy, :best] do
      post 'best'
      concerns :votable
      resources :comments, only: [:create]

    end
    concerns :votable
    resources :comments, only: [:create]

  end

  resources :attachments, only: [:purge_file] do
    delete :purge_file
  end

  resources :links, only: [:destroy]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
