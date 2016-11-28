Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config

  namespace :admin do
    resources :reports do
      collection do
        get :users_statistics
        get :question_with_answers
        get :question_responses
      end
    end
  end

  ActiveAdmin.routes(self)
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create, :show, :update]
      resources :sessions, only: [:create]
      resources :favorites, only: [:index, :create] do
        collection { delete :delete_collection }
      end
      resource :shopping_cart, only: [:create, :show, :destroy, :update] do
        member { put :finish }
      end
      resource :avatar, only: [:create]
      resources :blogentries, only: [:index, :show]
      resources :questions, only: [:index]
      resources :products, only: [:index] do
        collection { get :search }
      end
      resources :responses, only: [:index, :create, :update]
      resources :locations, only: [:index, :create, :destroy]
      get 'test_push' => 'users#test_push'
    end
  end

  get 'weather' => 'weather#retrieve_info', defaults: { format: 'json' }
  get 'locations' => 'weather#autocomplete_query', defaults: { format: 'json' }
  get 'weathermap' => 'weather#retrieve_weathermap', defaults: { format: 'json' }
end
