require 'test_helper'

class LecturesControllerTest < ActionController::TestCase

  def login
    user = User.new
    user.set_role(:admin)
    session[:user_id] = user.id
    MaglevRecord.save
  end
  def logout
    session[:user_id] = nil
  end

  def setup
    login
  end
  def teardown
    User.clear
    MaglevRecord.save
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

  test "should create lecture" do
    prev_count = Lecture.count
    post :create, :lecture => { :title => 'A lecture', :description => 'An interesting lecture.'}
    assert_equal Lecture.count, prev_count + 1
    # assert_redirected_to lecture_path(assigns(:lecture))
    # assert_equal 'Post was successfully created.', flash[:notice]
  end

end
