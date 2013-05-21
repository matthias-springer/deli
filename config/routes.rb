Deli::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  post "login" => "sessions#create", :as => "login"
  get "signup" => "users#new", :as => "signup"

  root :to => 'welcome#index'

  # resources :sessions

  get "lectures/index.json" => "lectures#index_json", :as => "lectures_json"
  resources :lectures
  put "lectures/:id/join" => "lectures#join", :as => "join_lecture"
  delete "lectures/:id/leave" => "lectures#leave", :as => "leave_lecture"

  get "lectures/:id/add/:role" => "lectures#add_user_list", :as => "add_user_list"
  put "lectures/:id/add/:role" => "lectures#add_user", :as => "add_user"
  delete "lectures/:id/remove/:role" => "lectures#remove_user", :as => "remove_user"

  get "users/students.json" => "users#json_students", :as => "json_students"
  get "users/tutors.json" => "users#json_tutors", :as => "json_tutors"
  resources :users, :except => :index
  delete "users/:id/leave/studentgroup" => "users#leave_group"

  get "studentgroups/list_for_join" => "studentgroups#list_for_join", :as => "join_studentgroup_list"
  resources :studentgroups
  put "studentgroups" => "studentgroups#edit_temp", :as => "edit_new_temp"
  put "studentgroups/:id/edit" => "studentgroups#edit_temp", :as => "edit_temp"
  put "studentgroups/:id/join" => "studentgroups#join", :as => "join_studentgroup"
  delete "studentgroups/:id/leave" => "studentgroups#leave", :as => "leave_studentgroup"
end
