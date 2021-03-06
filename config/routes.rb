Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'
  resources :catalogs
  resources :schoolposts do
    collection do
      get 'search'
      post 'search'
    end
  end
  get '/schoolpostsapi', to: "schoolposts_api#index"
  
end
