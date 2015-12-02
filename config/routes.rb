Rails.application.routes.draw do

  resources :cats
  resources :cat_rental_requests, only: [:create, :new] do
    post "approve", on: :member
    post "deny", on: :member
  end
  resource :user, only: [:create, :new, :show]
  resource :session, only: [:new, :create, :destroy]

  root to: redirect("/cats")
end
