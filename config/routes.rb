TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :workplace do
    resources :organizations do
      resources :lecturers, except: :show
    end

    root :to => 'workplace#index'
  end

  root :to => 'application#main_page'
end
