Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    patch :add_points
    patch :low_points
  end
  resources :questions do
    resources :answers,
              shallow: true,
              only: [:create, :update, :destroy, :best] do
      post 'best'
      concerns :votable
    end
    concerns :votable
  end

  resources :attachments, only: [:purge_file] do
    delete :purge_file
  end

  resources :links, only: [:destroy]

  root to: 'questions#index'
end
