Rails.application.routes.draw do
  get 'rewards/index'

  devise_for :users
  root 'questions#index'

  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment_delete'

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
