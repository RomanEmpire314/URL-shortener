Rails.application.routes.draw do
  
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update] 
  end
  # might need to add :create to password

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  resources :users
  resources :urls
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  constraints Clearance::Constraints::SignedIn.new do
    get '/', to: 'users#user_dashboard'
  end
  
  constraints Clearance::Constraints::SignedOut.new do
    get '/', to: redirect('/sign_in')
  end
end
