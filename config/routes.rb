Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy, :best] do
      post 'best'
    end
  end

  resources :attachments, only: [:purge_file] do
    delete :purge_file
  end

  root to: 'questions#index'
end
