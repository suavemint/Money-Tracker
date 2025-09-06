Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route - dashboard
  root "dashboard#index"
  
  # Dashboard
  get "dashboard", to: "dashboard#index"
  
  # Resources with proper RESTful routes
  resources :accounts do
    resources :transactions, except: [:show]
    resources :statements, only: [:index, :show, :new, :create, :destroy]
  end
  
  resources :transactions, only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch :categorize
    end
  end
  
  resources :categories
  
  resources :statements, only: [:index, :show, :destroy] do
    member do
      post :parse_pdf
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
