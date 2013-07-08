TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :workplace do
    resources :organizations, :except => [:index] do
      resources :disciplines, :except => :show
      resources :lecturers, :except => [:show, :index] do
        post :import, :on => :collection
      end
      resources :memberships, :except => [:show, :index]

      resources :buildings, except: [:show, :index] do
        post :import, :on => :collection
        resources :classrooms, except: [:show, :index]
      end

      resources :timetables do
        put 'to_published'  => 'timetables#to_published', :on => :member
        put 'to_draft'  => 'timetables#to_draft', :on => :member
        resources :groups, except: [:index, :show]
        resources :lesson_times
        resources :weeks, except: [:index, :new, :edit] do
          get 'copy/new', :to => 'copy_week#new', :as => :new_copy
          post 'copy', :to => 'copy_week#create', :as => :copy
          resources :days, only: [] do
            resources :lessons, except: [:index, :show] do
              get 'to_copy', :on => :member
              put 'copy', :on => :member
            end
          end
        end
      end
    end

    root :to => 'workplace#index'
  end

  root :to => 'application#main_page'
end
