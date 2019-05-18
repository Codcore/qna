Rails.application.routes.draw do
  get 'rewards/index'

  devise_for :users
  root 'questions#index'

  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment_delete'

  resources :questions do
    member do
      post 'up_vote'
      post 'down_vote'
    end

    resources :answers, shallow: true, except: [:index, :show, :new, :edit] do
      member do
        post 'best_solution'
        post 'up_vote'
        post 'down_vote'
      end
    end
  end
end
