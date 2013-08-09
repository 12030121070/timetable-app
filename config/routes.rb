TimetableApp::Application.routes.draw do
  devise_for :users

  namespace :manage do
    root :to => 'manage#index'
    resource :tariff, :only => [:edit, :update]
    resources :organizations do
      resources :subscriptions, :except => [:show] do
        get '/change_active_state' => 'subscriptions#change_active_state', :as => :change_active_state, :on => :member
      end
    end
  end

  namespace :workplace do
    resources :organizations, :only => [:new, :create, :edit, :update]

    resources :disciplines, :except => :show

    resources :lecturers do
      post :import, :on => :collection
    end

    resources :memberships, :except => [:show, :edit, :update]
    resources :subscriptions, :only => [:index, :new, :create]

    resources :buildings, except: [:show] do
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

        get 'pdf', :to => 'weeks#pdf', :on => :member

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

    root :to => 'workplace#index'
  end

  scope :module => :public do
    get '/' => 'organizations#show', :constraints => -> (r) { r.subdomain.present? }, :as => :organization
    get '/groups/:id' => 'groups#show', :constraints => -> (r) { r.subdomain.present? }, :as => :organization_group
    get '/lecturers/:id' => 'lecturers#show', :constraints => -> (r) { r.subdomain.present? }, :as => :organization_lecturer
  end

  root :to => 'application#main_page'
end
