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

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, except: [:index, :show, :new, :edit], concerns: [:votable] do
      member do
        post 'best_solution'
      end
    end
  end

  mount ActionCable.server => '/cable'
end
