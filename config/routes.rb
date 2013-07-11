TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :manage do
    root :to => 'manage#index'
  end

  namespace :workplace do
    resources :organizations, :except => [:index] do
      resources :disciplines, :except => :show

      resources :lecturers, :except => [:show, :index] do
        post :import, :on => :collection
      end

      resources :memberships, :except => [:index, :show, :edit, :update]

      resources :buildings, except: [:show, :index] do
        post :import, :on => :collection
        resources :classrooms, except: [:show, :index]
      end

      resources :timetables do
        put 'to_draft'     => 'timetables#to_draft',     :on => :member
        put 'to_published' => 'timetables#to_published', :on => :member

        resources :groups, except: [:index, :show]
        resources :lesson_times

        resources :weeks, except: [:index, :new, :edit] do
          get 'copy/new', :to => 'copy_week#new',    :as => :new_copy
          post 'copy',    :to => 'copy_week#create', :as => :copy

          resources :days, only: [] do
            resources :lessons, except: [:index, :show] do
              get  'copies/new'    => 'lesson_copies#new',       :as => :new_copy
              get  'movements/new' => 'lesson_movements#new',    :as => :new_movement
              post 'copies'        => 'lesson_copies#create',    :as => :copies
              post 'movements'     => 'lesson_movements#create', :as => :movements
            end
          end
        end
      end
    end

    root :to => 'workplace#index'
  end

  scope :module => :public do
    match '/' => 'organizations#show', :constraints => -> (r) { r.subdomain.present? && Organization.pluck(:subdomain).include?(r.subdomain) }
  end

  root :to => 'application#main_page'
end
