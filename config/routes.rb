Deli::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  
  root :to => 'welcome#index'
  
  resources :lectures
  resources :users,           :except => :index
  resources :studentgroups,   :except => :index
  resources :sessions

  get "lectures/:id/add/:role" => "lectures#add_user_list", :as => "add_user_list"
  put "lectures/:id/add/:role" => "lectures#add_user", :as => "add_user"
  delete "lectures/:id/remove/:role" => "lectures#remove_user", :as => "remove_user"
  
  get "users/:id/join/studentgroup" => "users#join_group_list", :as => "join_group"
  put "users/:id/join/studentgroup" => "users#join_group", :as => "join_group_do"
  delete "users/:id/leave/studentgroup" => "users#leave_group", :as => "leave_group"

  get "users/json/students" => "users#json_students", :as => "json_students"
  get "users/json/tutors" => "users#json_tutors", :as => "json_tutors"

  put "studentgroups/:id/add_student" => "studentgroups#add_student", :as => "add_student"
  put "studentgroups/:id/add_tutor" => "studentgroups#add_tutor", :as => "add_tutor"

end
