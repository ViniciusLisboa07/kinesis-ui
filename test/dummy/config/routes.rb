Rails.application.routes.draw do
  mount KinesisUi::Engine => "/kinesis_ui"
  
  root "home#index"
  
  resources :home, only: [:index, :show] do
    collection do
      post :create_user
      delete :delete_user
    end
  end
end
