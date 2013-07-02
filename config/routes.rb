TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :workplace do
    resources :organizations, :except => [:index] do
      resources :lecturers, :except => [:show, :index]
      resources :memberships, :except => [:show, :index]

      resources :buildings, except: [:show, :index] do
        resources :classrooms, except: [:show, :index]
      end
    end

    root :to => 'workplace#index'
  end

  root :to => 'application#main_page'
end
