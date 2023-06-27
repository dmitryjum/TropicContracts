Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "contracts#index"

  resources :contracts, only: :index do
    collection do
      get :import_modal
      get :supplier
      post :import_csv
    end
  end
end
