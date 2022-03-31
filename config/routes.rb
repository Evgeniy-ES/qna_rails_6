Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, except: :index do
      get :mark_as_best
    end
  end

  root to: 'questions#index'
end
