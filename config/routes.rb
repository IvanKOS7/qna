Rails.application.routes.draw do
  devise_for :users

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
