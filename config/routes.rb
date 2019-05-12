Rails.application.routes.draw do
  get 'rewards/index'

  devise_for :users
  root 'questions#index'

  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment_delete'

  resources :questions do
    resources :answers, shallow: true, except: [:index, :show, :new, :edit] do
      member do
        post 'best_solution'
      end
    end
  end
end
