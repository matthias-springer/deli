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
  test "should redirect to root if logged in" do
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
  # json_students
  # json_tutors

end