Rails.application.routes.draw do
  resource :user, only: [:new, :create, :show] do
    resources :subs, only: :edit
  end
  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: [:destroy, :edit]
end
