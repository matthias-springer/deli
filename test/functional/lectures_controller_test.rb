require 'test_helper'

class LecturesControllerTest < ActionController::TestCase

  def login_student
    @user = User.new
    session[:user_id] = @user.id
    MaglevRecord.save
  end
  def login_admin
    @user.set_role(:admin)
    MaglevRecord.save
  end

  def logout
    session[:user_id] = nil
  end

  def setup
    login_student
  end
  def teardown
    User.clear
    MaglevRecord.save
  end

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
