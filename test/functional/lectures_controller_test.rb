require 'test_helper'
require "functional/controller_test_base"

class LecturesControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def setup
    login_student
    Lecture.new(lecture_params)
    User.new(user_params)
    MaglevRecord.save
  end
  def teardown
    User.clear
    Lecture.clear
    MaglevRecord.save
  end

  def lecture_params
    { title: 'A lecture', description: 'An interesting lecture.' }
  end
  def user_params
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'test@email.com',
      password: 'pass'
    }
  end

  test "should not get index without authorization" do
    logout
    assert_raise(CanCan::AccessDenied) do
      get :index
    end
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lectures)
  end

  test "should show lecture" do
    l = Lecture.first
    get :show, id: l.id
    assert_response :success
    assert_not_nil assigns(:lecture)
    assert_equal l, assigns(:lecture)
  end

  test "should not show lecture when given invalid lecture id" do
    get :show, id: 3
    assert_response 302
    assert_nil assigns(:lecture)
    assert_redirected_to lectures_path
    assert_equal "Diese Vorlesung existiert nicht!", flash[:error]
  end

  test "should get new" do
    login_admin
    get :new
    assert_response :success
    assert_not_nil assigns(:lecture)
  end

  test "should create lecture" do
    login_admin
    prev_count = Lecture.count
    post :create, lecture: lecture_params
    assert_equal Lecture.count, prev_count + 1
    assert_redirected_to lectures_path
  end

  test "should get edit" do
    login_admin
    get :edit, id: Lecture.first.id
    assert_response :success
    assert_not_nil assigns(:lecture)
  end

  test "should update lecture" do
    login_admin
    params = lecture_params
    params[:title] = "Another lecture"
    assert_equal, Lecture.first.title = "A lecture"
    put :update, id: Lecture.first.id, lecture: params
    assert_equal, Lecture.first.title = "Another lecture"
  end
  test "should not update invalid lecture" do
    login_admin
    params = lecture_params
    params[:title] = "Another lecture"
    assert_equal, Lecture.first.title = ""
    put :update, id: Lecture.first.id, lecture: params
    assert_equal, Lecture.first.title = "A lecture"
  end

  test "should destroy lecture" do
    login_admin
    assert_equal Lecture.size, 1
    delete :destroy, id: Lecture.first.id
    assert_equal Lecture.size, 0
  end

  test "should not destroy non-existing lecture" do
    login_admin
    assert_equal Lecture.size, 1
    delete :destroy, id: 3
    assert_equal Lecture.size, 1
  end

  test "should join lecture" do
    request.env["HTTP_REFERER"] = "http://www.google.de"
    assert_equal Lecture.first.students.size, 0
    put :join, id: Lecture.first.id
    assert_equal Lecture.first.students.size, 1
    assert_redirected_to "http://www.google.de"
  end

  test "should leave lecture" do
    request.env["HTTP_REFERER"] = "http://www.google.de"
    Lecture.first.add_student(User.first)
    assert_equal Lecture.first.students.size, 1
    delete :leave, id: Lecture.first.id
    assert_equal Lecture.first.students.size, 0
    assert_redirected_to "http://www.google.de"
  end

  test "should show add_user_list" do
    login_admin
    get :add_user_list, id: Lecture.first.id, role: 'admin'
    assert_not_nil assigns(:users)
    assert_template 'add_user_list'
  end

  test "should add an user" do
    login_admin
    assert_equal Lecture.first.lecturers.size, 0
    put :add_user, id: Lecture.first.id, user_id: User.first.id, role: :lecturer
    assert_equal Lecture.first.lecturers.size, 1
  end

  test "should not add a non-existing user" do
    login_admin
    assert_equal Lecture.first.lecturers.size, 0
    put :add_user, id: Lecture.first.id, user_id: 3, role: :lecturer
    assert_equal Lecture.first.lecturers.size, 0
  end

  test "should not add an user with wrong role" do
    login_admin
    assert_equal Lecture.first.lecturers.size, 0
    put :add_user, id: Lecture.first.id, user_id: User.first.id, role: :wrong_role
    assert_equal Lecture.first.lecturers.size, 0
  end

  test "should remove an user" do
    login_admin
    Lecture.first.add_user(User.first, :lecturer)
    assert_equal Lecture.first.lecturers.size, 1
    delete :remove_user, id: Lecture.first.id, user_id: User.first.id, role: :lecturer
    assert_equal Lecture.first.lecturers.size, 0
    assert_redirected_to lecture_path(Lecture.first)
  end

  test "should not remove an user with wrong role" do
    login_admin
    Lecture.first.add_user(User.first, :lecturer)
    assert_equal Lecture.first.lecturers.size, 1
    delete :remove_user, id: Lecture.first.id, user_id: User.first.id, role: :lecturer
    assert_equal Lecture.first.lecturers.size, 0
    assert_redirected_to lecture_path(Lecture.first)
  end

  test "should get index json" do
    login_admin
    get :index_json
    assert_response :success
  end

end
