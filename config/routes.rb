Rails.application.routes.draw do
  use_doorkeeper

  get 'rewards/index'

  devise_for :users, controllers: { omniauth_callbacks: 'o_auth_callbacks' }
  root 'questions#index'

  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment_delete'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  concern :votable do
    member do
      post 'up_vote'
      post 'down_vote'
    end
  end

  concern :commentable do
    resources :commentaries, only: [:create, :update, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, except: [:index, :show, :new, :edit], concerns: [:votable, :commentable] do
      member do
        post 'best_solution'
      end
    end
  end

  mount ActionCable.server => '/cable'
end
