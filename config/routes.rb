Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"

    get "/about-us", to: "static_pages#about_us"
    get "/contact-us", to: "static_pages#contact_us"
    get "/car-list", to: "posts#index"
    post "favorite_lists/update"
    post "posts/update_index"
    devise_for :users

    devise_scope :user do
      get "signup", to: "users/registrations#new"
      post "signup", to: "users/registrations#create"
      get "login", to: "users/sessions#new"
      post "login", to: "users/sessions#create"
      delete "logout", to: "users/sessions#destroy"
    end

    resources :favorite_lists, only: %i(show update index)
    resources :posts
    resources :users, only: %i(show new create)
    resources :posts do
      resources :comments, only: %i(new create destroy)
    end
    resources :comments, only: %i(new create destroy) do
      resources :comments, only: %i(new create destroy)
    end

    namespace :admins do
      root "posts#index"
      post "posts/change_activated"
      resources :posts
    end
    mount Ckeditor::Engine => '/ckeditor'
  end
end
