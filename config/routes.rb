Deli::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  post "login" => "sessions#create", :as => "login"
  get "signup" => "users#new", :as => "signup"
  
  root :to => 'welcome#index'
  
  # resources :sessions

  resources :lectures
  put "lectures/:id/join" => "lectures#join", :as => "join_lecture"
  delete "lectures/:id/leave" => "lectures#leave", :as => "leave_lecture"

  get "lectures/:id/add/:role" => "lectures#add_user_list", :as => "add_user_list"
  put "lectures/:id/add/:role" => "lectures#add_user", :as => "add_user"
  delete "lectures/:id/remove/:role" => "lectures#remove_user", :as => "remove_user"
  
  resources :users,           :except => :index
  get "users/:id/join/studentgroup" => "users#join_group_list", :as => "join_group"
  put "users/:id/join/studentgroup" => "users#join_group", :as => "join_group_do"
  delete "users/:id/leave/studentgroup" => "users#leave_group", :as => "leave_group"

  get "users/json/students" => "users#json_students", :as => "json_students"
  get "users/json/tutors" => "users#json_tutors", :as => "json_tutors"

  resources :studentgroups
  put "studentgroups" => "studentgroups#update_from_session", :as => "update_new_studentgroup"
  put "studentgroups/:id/edit" => "studentgroups#update_from_session", :as => "update_studentgroup"
  # put "studentgroup/add_student" => "studentgroups#add_student", :as => "add_student"
  # put "studentgroup/add_tutor" => "studentgroups#add_tutor", :as => "add_tutor"

end
