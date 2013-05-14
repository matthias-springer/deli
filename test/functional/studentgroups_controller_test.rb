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
    clear_group_session
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

  def clear_group_session
    session.delete(:group)
  end

  test "guest cannot list groups" do
    logout
    assert_raise(CanCan::AccessDenied) do
      get :index
    end    
  end

  test "new-action should create entry in session" do
    get :new
    assert_not_nil session[:group]
  end

  test "should be able to create new group successfully" do
    l = Lecture.new({:title => "New Lecture", :description => "This is really good!"})
    MaglevRecord.save
    old_count = Studentgroup.size
    
    create_clear_session
    post :create, :studentgroup_name => "new group", :chosen_lecture => l.id
    assert_redirected_to studentgroups_path
    
    assert_not_nil assigns(:group)
    assert_equal old_count+1, Studentgroup.size

    assert_nil session[:group]
  end


  test "creating invalid group shoul render to 'new'" do
    create_clear_session

    post :create, :studentgroup_name => "new group", :chosen_lecture => 2
    assert_response :success
    assert_equal flash[:error], "Die Vorlesung existiert nicht!"

    l = Lecture.new({:title => "New Lecture", :description => "This is really good!"})
    MaglevRecord.save
    post :create, :chosen_lecture => l.id
    assert_response :success

    assert_not_nil session[:group]
    
  end


  test "should show studentgroup" do
    login_admin
    l = Lecture.new({:title => "New Lecture", :description => "This is really good!"})
    group = Studentgroup.new({:name => "New group", :lecture => l})
    MaglevRecord.save
    get :show, :id => group.id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_equal assigns(:group), group
  end

end