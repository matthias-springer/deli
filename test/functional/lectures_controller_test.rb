require 'test_helper'
require "functional/controller_test_base"

class LecturesControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def lecture_attrs
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
    l = Lecture.new(lecture_attrs)
    MaglevRecord.save
    get :show, :id => l.id
    assert_response :success
    assert_not_nil assigns(:lecture)
    assert_equal l, assigns(:lecture)
  end

  test "should create lecture" do
    login_admin
    prev_count = Lecture.count
    post :create, :lecture => lecture_attrs
    assert_equal Lecture.count, prev_count + 1
    # assert_redirected_to lecture_path(assigns(:lecture))
    # assert_equal 'Post was successfully created.', flash[:notice]
  end

end
