TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :workplace do
    resource :organization
    root :to => 'workplace#index'
  end

  root :to => 'application#main_page'
end
