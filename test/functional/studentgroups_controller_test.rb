require 'test_helper'
require "functional/controller_test_base"

class StudentgroupsControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def setup
    login_student
  end

  def teardown
    [User, Lecture, Studentgroup].each do |cls| cls.clear end
    MaglevRecord.save
  end

  def create_clear_session
    session[:group] = {
        :name => "",
        :lecture => [nil, ""],
        :students => {@user.id => @user.to_s},
        :tutors => {},
        :is_new => true
      }
  end

  test "should be able to create new group" do
    l = Lecture.new({:title => "New Lecture", :description => "This is really good!"})
    MaglevRecord.save
    old_count = Studentgroup.size
    create_clear_session
    post :create, :group => {:name => "new group", :lecture => l}
    assert_response :success
    assert_not_nil assigns(:group)
    groups = Studentgroup.all
    assert_equal old_count+1, Studentgroup.size
  end

  test "guest cannot list groups" do
    logout
    assert_raise(CanCan::AccessDenied) do
      get :index
    end    
  end

  test "should show studentgroup" do
    login_admin
    group = Studentgroup.new(:name => "New group")
    MaglevRecord.save
    get :show, :id => group.id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_equal assigns(:group), group
  end
end