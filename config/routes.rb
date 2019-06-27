require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  get 'rewards/index'

  devise_for :users, controllers: { omniauth_callbacks: 'o_auth_callbacks' }
  root 'questions#index'

  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment_delete'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:show, :create]
      end
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
    member do
      post 'subscribe'
      delete 'unsubscribe'
    end
  end

  mount ActionCable.server => '/cable'
end
