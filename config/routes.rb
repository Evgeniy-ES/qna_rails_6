require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :answers, concerns: [:voted, :commented], shallow: true, except: :index do
      get :mark_as_best
    end
  end

  namespace :api do
   namespace :v1 do
     resources :profiles, only: [] do
       get :me, on: :collection
        get :all, on: :collection
     end

     resources :questions, except: [:edit, :new] do
        resources :answers, except: [:edit, :new], shallow: true
      end
   end
 end


  resources :files, only: %i[destroy]
  resources :links, only: :destroy


  mount ActionCable.server => '/cable'

  get 'search', action: :search, controller: 'search'
end
