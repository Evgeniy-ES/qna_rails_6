Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, except: :index do
      get :mark_as_best
    end
  end

  resources :files, only: %i[destroy]

  root to: 'questions#index'
end
