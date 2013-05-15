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
        name: "",
        lecture: [nil, ""],
        students: {@user.id => @user.to_s},
        tutors: {},
        is_new: true
      }
  end

  def create_session_from_group(group)
    session[:group] = {
      id: group.id,
      name: group.name,
      lecture: [group.lecture.id, group.lecture.title],
      students: {@user.id => @user.to_s},
      tutors: {},
      is_new: false
    }
  end

  def clear_group_session
    session.delete(:group)
  end

  # index
  test "guest cannot list groups" do
    logout
    assert_raise(CanCan::AccessDenied) do
      get :index
    end
  end

  # new
  test "new-action should create entry in session" do
    get :new
    group_info = session[:group]
    assert_not_nil group_info
    assert group_info[:is_new]
  end

  # create
  test "should be able to create new group successfully" do
    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    MaglevRecord.save
    old_count = Studentgroup.size

    create_clear_session
    post :create, studentgroup_name: "new group", chosen_lecture: l.id
    assert_redirected_to studentgroups_path

    assert_not_nil assigns(:group)
    assert_equal old_count+1, Studentgroup.size

    assert_nil session[:group]
  end
  test "creating invalid group shoul render to 'new'" do
    create_clear_session

    post :create, studentgroup_name: "new group", chosen_lecture: 2
    assert_response :success
    assert_equal flash[:error], "Die Vorlesung existiert nicht!"

    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    MaglevRecord.save
    post :create, chosen_lecture: l.id
    assert_response :success

    assert_not_nil session[:group]
  end

  def create_test_group
    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    @group = Studentgroup.new({name: "New group", lecture: l})
    MaglevRecord.save
  end

  # show
  test "should show studentgroup" do
    login_admin
    create_test_group
    get :show, id: @group.id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_equal assigns(:group), @group
  end

  # destroy
  test "destroy not existing studentgroup" do
    login_admin
    delete :destroy, id: 1
    assert_redirected_to studentgroups_path
    assert_equal flash[:error], "Gruppe ist nicht vorhanden!"
    assert_nil flash[:notice]
  end
  test "destroy existing studentgroup" do
    login_admin
    create_test_group
    counter = Studentgroup.size
    delete :destroy, id: @group.id
    assert_redirected_to studentgroups_path
    assert_equal flash[:notice], "Gruppe erfolgreich gelöscht!"
    assert_nil flash[:error]
    assert_equal Studentgroup.size, counter-1
    assert_nil Studentgroup.find_by_objectid(@group.id)
  end


  def map_list(user_list)
    result = {}
    user_list.each { |user| result[user.id] = user.to_s}
    result
  end

  # edit
  test "edit" do
    login_admin
    create_test_group
    get :edit, id: @group.id
    group_info = session[:group]

    assert_not_nil group_info
    assert(!group_info[:is_new])
    assert_equal group_info[:name], @group.name
    assert_equal group_info[:lecture],  [@group.lecture.id, @group.lecture.title]
    [:students, :tutors].each do |key|
      assert_equal group_info[key], map_list(@group.attributes[key]), "#{key.to_s} check fails"
    end
  end

  # update
  test "update with errors" do
    login_admin
    create_test_group

    session[:group] = {id: 1}
    put :update, id: @group.id
    assert_redirected_to studentgroups_path
    assert_equal flash[:error], "Die Gruppe existiert nicht!"

    create_session_from_group(@group)
    put :update, id: @group.id
    assert_redirected_to studentgroups_path
    assert_equal flash[:error], "Die Vorlesung existiert nicht!"
  end

  test "update is invalid" do
    login_admin
    create_test_group

    create_session_from_group(@group)
    params = {
      id: @group.id,
      chosen_lecture: @group.lecture.id,
      studentgroup_name: ""
    }
    put :update, params
    assert_response :success
    assert_template "edit"
  end

  test "successfull update" do
    login_admin
    create_test_group

    create_session_from_group(@group)
    params = {
      id: @group.id,
      chosen_lecture: @group.lecture.id,
      studentgroup_name: @group.name
    }

    put :update, params
    assert_redirected_to studentgroups_path
  end

  # edit_temp
  test "update new studentgroup with not existing student" do
    login_admin
    create_test_group
    create_clear_session
    params = {
      chosen_student: "1",
      chosen_tutor: "",
      chosen_lecture: @group.lecture.id,
      add_student: "",
    }
    put :edit_temp, params

    assert_equal flash[:error], "Benutzer existiert nicht!"
  end

  # test "update new studentgroup with not existing student" do
  #   login_admin
  #   create_test_group
  #   create_clear_session

  #   put :edit_temp, params_with_none_existing_student

  #   assert flash[:error].contains?("Benutzer existiert nicht!")
  # end

end