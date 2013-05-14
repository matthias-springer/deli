require 'test_helper'
require "functional/controller_test_base"

class LecturesControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def setup
    login_student
    Lecture.new(lecture_params)
    MaglevRecord.save
  end
  def teardown
    User.clear
    Lecture.clear
    MaglevRecord.save
  end

  def lecture_params
    { :title => 'A lecture', :description => 'An interesting lecture.'}
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
    get :show, :id => l.id
    assert_response :success
    assert_not_nil assigns(:lecture)
    assert_equal l, assigns(:lecture)
  end

  test "should create lecture" do
    login_admin
    prev_count = Lecture.count
    post :create, :lecture => lecture_params
    assert_equal Lecture.count, prev_count + 1
    assert_redirected_to lectures_path
  end

  test "should get edit" do
    login_admin
    get :edit, :id => Lecture.first.id
    assert_response :success
    assert_not_nil assigns(:lecture)
  end

  test "should update lecture" do
    login_admin
    params = lecture_params
    params[:title] = "Another lecture"
    assert_equal, Lecture.first.title = "A lecture"
    put :update, :id => Lecture.first.id, :lecture => params
    assert_equal, Lecture.first.title = "Another lecture"
  end
end
