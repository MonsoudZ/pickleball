Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "about", to: "pages#about", as: :about
  get "faq", to: "pages#faq", as: :faq
  get "pricing", to: "pages#pricing", as: :pricing
  get "contact", to: "pages#contact", as: :contact
  post "contact", to: "pages#create_contact"
  get "policies", to: "pages#policies", as: :policies
  get "sitemap.xml", to: "sitemap#show", defaults: { format: :xml }, as: :sitemap
  get "robots.txt", to: "sitemap#robots", defaults: { format: :text }

  get "calendar", to: "training_sessions#index", as: :calendar
  resources :training_sessions, only: :show
end
