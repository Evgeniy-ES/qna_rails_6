Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  resources :users, only: :rewards do
   member do
     get :rewards
   end
  end

  concern :voted do
    member do
      put :vote_for
      put :vote_against
      delete :cancel_voting
    end
  end

  concern :commented do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers, concerns: [:voted, :commented], shallow: true, except: :index do
      get :mark_as_best
    end
  end


  resources :files, only: %i[destroy]
  resources :links, only: :destroy


 mount ActionCable.server => '/cable'
end
