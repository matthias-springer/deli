require 'test_helper'
require "functional/controller_test_base"

class UsersControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def setup
    login_student
  end

  def teardown
    [User, Lecture, Studentgroup].each do |cls| cls.clear end
    MaglevRecord.save
  end

  # show
  test "should show a user" do
    login_admin
    u = User.new({ first_name: "Vorname", last_name: "Name" })
    MaglevRecord.save
    get :show, id: u.id
    assert_response :success
    assert_template "show"
  end

  test "should show my profile" do
    login_admin
    get :show, id: @user
    assert_response :success
    assert_template "profile"
  end

  # edit TODO
  # update TODO
  # destroy TODO

  # new
  test "new should redirect to root if logged in" do
    get :new
    assert_redirected_to root_url
  end

  test "should go to sign up site" do
    logout
    get :new
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template "new"
  end

  # create
  test "create should redirect to root if logged in" do
    post :create
    assert_redirected_to root_url
  end

  test "should say the passwort confirm did not match" do
    logout
    params = {
      user: {
        first_name: "User1",
        last_name: "Nachname1",
        email: "test@test.com",
        password: "pass",
        password_confirmation: "other_pass"
      }
    }

    old_count = User.size
    post :create, params
    MaglevRecord.reset
    assert_equal User.size, old_count

    assert_response :success
    assert_template "new"
    assert_not_nil assigns(:user)
    assert !(assigns(:user).errors.empty?)
  end

  test "should create new user" do
    logout

    params = {
      user: {
        first_name: "User2",
        last_name: "Nachname2",
        email: "test@test.com",
        password: "pass",
        password_confirmation: "pass"
      }
    }

    old_count = User.size
    post :create, params
    assert_not_nil assigns(:user)
    assert assigns(:user).valid?, assigns(:user).errors.full_messages
    assert_redirected_to root_url

    MaglevRecord.reset
    assert_equal User.size, old_count + 1

    user = User.find { |user| user.last_name == "Nachname2"}
    assert_equal user.first_name, "User2"
  end
  # json_students
  # json_tutors

end